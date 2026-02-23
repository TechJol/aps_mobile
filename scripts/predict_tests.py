#!/usr/bin/env python3
"""Select prioritized Flutter tests from changed files.

MVP selector for CI:
- Reads changed files list.
- Finds tests under test/**/*_test.dart.
- Scores tests by path-token overlap with changed files.
- Writes selected tests to output (one path per line).

This is intentionally lightweight and dependency-free so it can run in CI
without a trained model. Later you can replace `score_test` with ML inference.
"""

from __future__ import annotations

import argparse
import pathlib
import re
import sys
from collections import defaultdict
from typing import Iterable, List, Set


TOKEN_RE = re.compile(r"[a-zA-Z0-9]+")


def normalize_tokens(path: str) -> Set[str]:
    return {t.lower() for t in TOKEN_RE.findall(path)}


def read_lines(path: pathlib.Path) -> List[str]:
    if not path.exists():
        return []
    return [line.strip() for line in path.read_text(encoding="utf-8").splitlines() if line.strip()]


def discover_tests(test_root: pathlib.Path) -> List[pathlib.Path]:
    if not test_root.exists():
        return []
    return sorted(test_root.rglob("*_test.dart"))


def score_test(test_path: pathlib.Path, changed_files: Iterable[str]) -> float:
    """Simple heuristic score based on lexical overlap.

    Higher score => higher chance test is related to changed files.
    """
    test_str = test_path.as_posix()
    test_tokens = normalize_tokens(test_str)
    if not test_tokens:
        return 0.0

    best = 0.0
    for changed in changed_files:
        changed_tokens = normalize_tokens(changed)
        if not changed_tokens:
            continue

        overlap = len(test_tokens & changed_tokens)
        if overlap == 0:
            continue

        # Favor strong overlap and matching feature folders.
        union = len(test_tokens | changed_tokens)
        jaccard = overlap / union if union else 0.0

        feature_bonus = 0.0
        if "/feature/" in changed and "/feature/" in test_str:
            changed_parts = changed.split("/")
            test_parts = test_str.split("/")
            common_parts = len(set(changed_parts) & set(test_parts))
            feature_bonus = min(common_parts * 0.05, 0.25)

        score = jaccard + feature_bonus
        if score > best:
            best = score

    return best


def select_tests(
    all_tests: List[pathlib.Path],
    changed_files: List[str],
    top_k: int,
) -> List[pathlib.Path]:
    if not all_tests:
        return []

    # If no changed files provided, return all tests (safe fallback).
    if not changed_files:
        return all_tests

    scored = []
    for test_path in all_tests:
        s = score_test(test_path, changed_files)
        if s > 0:
            scored.append((s, test_path))

    if not scored:
        # No lexical match; return all tests to avoid false negatives.
        return all_tests

    scored.sort(key=lambda x: x[0], reverse=True)

    selected: List[pathlib.Path] = []
    for _, path in scored:
        selected.append(path)
        if len(selected) >= top_k:
            break

    # Guarantee at least one test if top_k is 0 or weird config.
    if not selected:
        selected = [scored[0][1]]

    return selected


def write_output(paths: Iterable[pathlib.Path], out_path: pathlib.Path) -> None:
    out_path.parent.mkdir(parents=True, exist_ok=True)
    content = "\n".join(p.as_posix() for p in paths)
    out_path.write_text(content + ("\n" if content else ""), encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description="Prioritize Flutter tests for CI")
    parser.add_argument("--changed-files", required=True, help="Path to changed files list")
    parser.add_argument("--output", required=True, help="Path to selected tests output file")
    parser.add_argument("--test-root", default="test", help="Flutter test root directory")
    parser.add_argument("--top-k", type=int, default=40, help="Max tests to select")

    args = parser.parse_args()

    changed_path = pathlib.Path(args.changed_files)
    output_path = pathlib.Path(args.output)
    test_root = pathlib.Path(args.test_root)
    top_k = max(1, args.top_k)

    changed_files = read_lines(changed_path)
    all_tests = discover_tests(test_root)

    selected = select_tests(all_tests=all_tests, changed_files=changed_files, top_k=top_k)
    write_output(selected, output_path)

    print(f"Changed files: {len(changed_files)}")
    print(f"Discovered tests: {len(all_tests)}")
    print(f"Selected tests: {len(selected)}")
    for p in selected:
        print(f" - {p.as_posix()}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
