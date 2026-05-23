from __future__ import annotations

import re
from pathlib import Path
from typing import Iterable

import pandas as pd


TOKEN_RE = re.compile(r"[a-zA-Z0-9]+")
STOP_TOKENS = {
    "dart",
    "data",
    "domain",
    "feature",
    "features",
    "lib",
    "page",
    "pages",
    "presentation",
    "src",
    "test",
    "tests",
    "unit",
    "widget",
    "widgets",
    "cubit",
    "state",
    "impl",
    "repository",
    "repositories",
    "usecase",
    "usecases",
}
FEATURES = {
    "account",
    "auth",
    "core",
    "home",
    "income",
    "main",
    "menu",
    "operation",
    "pages",
    "payment",
    "network",
    "routes",
    "theme",
    "widgets",
}
LAYERS = {"data", "domain", "presentation", "core", "logic", "pages"}


def tokens(value: str) -> set[str]:
    return {
        token.lower()
        for token in TOKEN_RE.findall(value)
        if token.lower() not in STOP_TOKENS
    }


def token_jaccard(left: str, right: str) -> float:
    left_tokens = tokens(left)
    right_tokens = tokens(right)
    if not left_tokens or not right_tokens:
        return 0.0
    return len(left_tokens & right_tokens) / len(left_tokens | right_tokens)


def infer_feature(path: str) -> str:
    normalized = path.replace("\\", "/")
    parts = normalized.split("/")

    if "/core/network/" in normalized:
        return "network"
    if "/core/utils/routes/" in normalized:
        return "routes"
    if "/core/widgets/" in normalized:
        return "widgets"
    if "/core/theme/" in normalized:
        return "theme"

    if "/feature/" in normalized:
        try:
            feature = parts[parts.index("feature") + 1]
            if feature in FEATURES:
                return feature
        except (ValueError, IndexError):
            pass

    if "/core/" in normalized:
        try:
            return parts[parts.index("core") + 1]
        except (ValueError, IndexError):
            return "core"

    for part in parts:
        if part in FEATURES:
            return part

    return "unknown"


def infer_layer(path: str) -> str:
    normalized = path.replace("\\", "/")
    parts = normalized.split("/")
    for part in parts:
        if part in LAYERS:
            return part
    if "/core/" in normalized:
        return "core"
    return "unknown"


def path_depth(path: str) -> int:
    return len([part for part in path.replace("\\", "/").split("/") if part])


def discover_source_files(root: Path) -> list[Path]:
    source_roots = [root / "lib" / "src" / "feature", root / "lib" / "src" / "core"]
    files: list[Path] = []
    for source_root in source_roots:
        if source_root.exists():
            files.extend(source_root.rglob("*.dart"))
    return sorted(path for path in files if "/generated/" not in path.as_posix())


def load_inventory(path: Path) -> pd.DataFrame:
    inventory = pd.read_csv(path)
    required = {"test_id", "path", "type", "feature", "manual_priority"}
    missing = required - set(inventory.columns)
    if missing:
        raise ValueError(f"Inventory is missing required columns: {sorted(missing)}")
    inventory = inventory.dropna(subset=["test_id", "path"]).copy()
    inventory["path"] = inventory["path"].astype(str)
    inventory["test_id"] = inventory["test_id"].astype(str)
    inventory["feature"] = inventory["feature"].fillna("unknown")
    inventory["type"] = inventory["type"].fillna("unknown")
    inventory["manual_priority"] = inventory["manual_priority"].fillna(1).astype(float)
    return inventory


def build_pair_features(
    changed_file: str,
    test_path: str,
    test_type: str,
    test_feature: str,
    manual_priority: float,
) -> dict[str, float | int | str]:
    changed_feature = infer_feature(changed_file)
    changed_layer = infer_layer(changed_file)
    test_layer = infer_layer(test_path)
    overlap = token_jaccard(changed_file, test_path)

    changed_tokens = tokens(changed_file)
    test_tokens = tokens(test_path)
    common_tokens = len(changed_tokens & test_tokens)

    return {
        "changed_file": changed_file,
        "test_path": test_path,
        "test_type": test_type,
        "changed_feature": changed_feature,
        "test_feature": test_feature,
        "changed_layer": changed_layer,
        "test_layer": test_layer,
        "same_feature": int(changed_feature == test_feature),
        "same_layer": int(changed_layer == test_layer),
        "token_jaccard": overlap,
        "common_token_count": common_tokens,
        "manual_priority": float(manual_priority),
        "changed_depth": path_depth(changed_file),
        "test_depth": path_depth(test_path),
        "changed_is_core": int(changed_file.startswith("lib/src/core/")),
        "changed_is_feature": int("/feature/" in changed_file),
        "changed_is_network": int(changed_feature == "network"),
        "changed_is_routes": int(changed_feature == "routes"),
        "changed_is_widgets": int(changed_feature == "widgets"),
        "changed_is_theme": int(changed_feature == "theme"),
        "test_feature_is_pages": int(test_feature == "pages"),
        "test_feature_is_core": int(test_feature == "core"),
        "test_path_has_widget": int("widget" in test_path),
        "test_path_is_global_smoke": int(test_path == "test/widget_test.dart"),
        "is_unit_test": int(test_type == "unit"),
        "is_widget_test": int(test_type == "widget"),
        "is_integration_test": int(test_type == "integration"),
        "high_business_priority": int(float(manual_priority) >= 4),
    }


def relevance_label(features: dict[str, float | int | str]) -> int:
    if features["same_feature"] == 1:
        return 1
    if features["changed_feature"] in {"theme", "network", "utils", "constants"}:
        return int(features["test_feature"] in {"core", "auth", "payment", "menu"})
    if features["changed_feature"] == "routes":
        return int(
            features["test_feature"] == "pages"
            or features["test_path_is_global_smoke"] == 1
        )
    if features["changed_feature"] == "widgets":
        return int(
            features["test_type"] == "widget"
            or features["test_feature"] == "pages"
            or features["test_path_is_global_smoke"] == 1
        )
    if features["test_feature"] == "pages" and features["common_token_count"] >= 2:
        return 1
    return int(features["token_jaccard"] >= 0.18 and features["manual_priority"] >= 3)


def build_prediction_frame(
    changed_files: Iterable[str],
    inventory: pd.DataFrame,
) -> pd.DataFrame:
    rows: list[dict[str, float | int | str]] = []
    for changed_file in changed_files:
        for _, test in inventory.iterrows():
            rows.append(
                build_pair_features(
                    changed_file=changed_file,
                    test_path=test["path"],
                    test_type=test["type"],
                    test_feature=test["feature"],
                    manual_priority=test["manual_priority"],
                )
            )
    return pd.DataFrame(rows)


FEATURE_COLUMNS = [
    "same_feature",
    "same_layer",
    "token_jaccard",
    "common_token_count",
    "manual_priority",
    "changed_depth",
    "test_depth",
    "changed_is_core",
    "changed_is_feature",
    "changed_is_network",
    "changed_is_routes",
    "changed_is_widgets",
    "changed_is_theme",
    "test_feature_is_pages",
    "test_feature_is_core",
    "test_path_has_widget",
    "test_path_is_global_smoke",
    "is_unit_test",
    "is_widget_test",
    "is_integration_test",
    "high_business_priority",
]
