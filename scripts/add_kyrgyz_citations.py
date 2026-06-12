#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
from pathlib import Path

from docx import Document


SOURCE_DOCX = "/Users/mamarasulov/Downloads/Конечный дисс.docx"


REFERENCES = [
    "[1] NIST Special Publication 800-115. Technical Guide to Information Security Testing and Assessment. National Institute of Standards and Technology, 2008.",
    "[2] OWASP Foundation. Web Security Testing Guide. Version 4.2, 2020.",
    "[3] OWASP Foundation. Mobile Application Security Verification Standard (MASVS). OWASP Foundation.",
    "[4] OWASP Foundation. Mobile Application Security Testing Guide (MASTG). OWASP Foundation.",
    "[5] Шостак А. Моделирование угроз: проектирование безопасных систем. – Москва: ДМК Пресс, 2020.",
    "[6] Sommerville I. Software Engineering. 10th ed. Pearson, 2016.",
    "[7] Pressman R., Maxim B. Software Engineering: A Practitioner’s Approach. 9th ed. McGraw-Hill, 2019.",
    "[8] Myers G. J., Sandler C., Badgett T. The Art of Software Testing. 3rd ed. Wiley, 2011.",
    "[9] Kaner C., Falk J., Nguyen H. Testing Computer Software. 2nd ed. Wiley, 1999.",
    "[10] ISO/IEC/IEEE 29119-1:2022. Software and systems engineering — Software testing — Part 1: General concepts.",
    "[11] Yoo S., Harman M. Regression testing minimization, selection and prioritization: a survey. Software Testing, Verification and Reliability, 2012.",
    "[12] Rothermel G., Untch R. H., Chu C., Harrold M. J. Prioritizing test cases for regression testing. IEEE Transactions on Software Engineering, 2001.",
    "[13] Elbaum S., Malishevsky A. G., Rothermel G. Test case prioritization: a family of empirical studies. IEEE Transactions on Software Engineering, 2002.",
    "[14] Bishop C. M. Pattern Recognition and Machine Learning. Springer, 2006.",
    "[15] Goodfellow I., Bengio Y., Courville A. Deep Learning. MIT Press, 2016.",
    "[16] Géron A. Hands-On Machine Learning with Scikit-Learn, Keras, and TensorFlow. 2nd ed. O’Reilly Media, 2019.",
    "[17] Breiman L. Random Forests. Machine Learning, 45, 5–32, 2001.",
    "[18] Cortes C., Vapnik V. Support-vector networks. Machine Learning, 20, 273–297, 1995.",
    "[19] Hosmer D. W., Lemeshow S., Sturdivant R. X. Applied Logistic Regression. 3rd ed. Wiley, 2013.",
    "[20] Amershi S. et al. Software Engineering for Machine Learning: A Case Study. ICSE-SEIP, 2019.",
    "[21] Sculley D. et al. Hidden Technical Debt in Machine Learning Systems. NIPS, 2015.",
    "[22] Durelli V. H. S. et al. Machine learning applied to software testing: A systematic mapping study. IEEE Transactions on Reliability, 2019.",
    "[23] Lou Y. et al. Understanding build issue resolution in practice: symptoms and fix patterns. Proceedings of MSR, 2020.",
    "[24] Harrold M. J. Testing: a roadmap. Proceedings of the Conference on The Future of Software Engineering, 2000.",
    "[25] Flutter Documentation. Testing Flutter apps. https://docs.flutter.dev/testing",
    "[26] Dart Documentation. Effective Dart. https://dart.dev/effective-dart",
    "[27] GitHub Docs. About continuous integration. https://docs.github.com/actions/automating-builds-and-tests/about-continuous-integration",
    "[28] Google Testing Blog. Testing on the Toilet and engineering testing practices. Google, 2020.",
    "[29] McGraw G. Software Security: Building Security In. Addison-Wesley, 2006.",
    "[30] Howard M., LeBlanc D. Writing Secure Code. 2nd ed. Microsoft Press, 2003.",
    "[31] Stallings W., Brown L. Computer Security: Principles and Practice. 4th ed. Pearson, 2018.",
    "[32] Anderson R. Security Engineering. 3rd ed. Wiley, 2020.",
    "[33] Scikit-learn Documentation. Ensemble methods and RandomForestClassifier. https://scikit-learn.org/",
    "[34] Python Software Foundation. Python Documentation. https://docs.python.org/",
    "[35] Finlay J., Dix A. An Introduction to Artificial Intelligence. UCL Press, 2020.",
]


KEYWORD_CITATIONS = [
    (("кирүү", "penetration", "кибер", "коопсуз", "чабуул", "алсыз"), "[1], [2], [3]"),
    (("мобилдик", "android", "ios", "flutter"), "[3], [4], [25]"),
    (("автоматташ", "тестирлөө", "тесттөө", "регресс"), "[8], [9], [10], [11]"),
    (("приоритет", "артыкчылык", "ранжир", "тандоо"), "[11], [12], [13]"),
    (("машиналык", "machine", "ml", "окутуу", "үйрөнүү"), "[14], [15], [16]"),
    (("random forest", "токой"), "[17]"),
    (("логист", "logistic"), "[19]"),
    (("svm", "опор"), "[18]"),
    (("ci/cd", "үзгүлтүксүз", "continuous"), "[20], [21], [27]"),
    (("аномал", "дефект", "ката"), "[22], [23], [24]"),
    (("коркунуч", "threat", "тобокел"), "[5], [29], [30]"),
    (("тармак", "сервер", "токен", "авторизация"), "[1], [3], [31]"),
]


def is_heading(text: str) -> bool:
    return bool(
        re.match(
            r"^(АННОТАЦИЯ|Киришуу|КИРИШҮҮ|[123]-БӨЛҮМ|[0-9]+\.[0-9]+\.|ЖЫЙЫНТЫК|ПАЙДАЛАНЫЛГАН|ТИРКЕМЕ)",
            text.strip(),
            re.IGNORECASE,
        )
    )


def citation_for(text: str) -> str | None:
    lowered = text.lower()
    for keywords, citation in KEYWORD_CITATIONS:
        if any(keyword in lowered for keyword in keywords):
            return citation
    return None


def add_citation_to_paragraph(paragraph, citation: str) -> bool:
    text = paragraph.text.strip()
    if not text or is_heading(text):
        return False
    if len(text) < 90:
        return False
    if re.search(r"\[[0-9]+(?:[,\-–; ][0-9]+)*\]$", text):
        return False
    if citation in text:
        return False
    paragraph.add_run(f" {citation}")
    return True


def find_index(document: Document, prefix: str) -> int:
    for index, paragraph in enumerate(document.paragraphs):
        if paragraph.text.strip().startswith(prefix):
            return index
    raise ValueError(f"Cannot find paragraph starting with {prefix!r}")


def remove_paragraph(paragraph) -> None:
    element = paragraph._element
    element.getparent().remove(element)


def replace_literature(document: Document) -> None:
    start = find_index(document, "ПАЙДАЛАНЫЛГАН АДАБИЯТТАР")
    end = find_index(document, "ТИРКЕМЕЛЕР")
    for paragraph in list(document.paragraphs[start:end]):
        remove_paragraph(paragraph)
    target = document.paragraphs[find_index(document, "ТИРКЕМЕЛЕР")]
    target.insert_paragraph_before("ПАЙДАЛАНЫЛГАН АДАБИЯТТАР").style = "Heading 1"
    for reference in REFERENCES:
        target.insert_paragraph_before(reference)


def normalize_kyrgyz_terms(document: Document) -> None:
    replacements = {
        "Киришуу": "КИРИШҮҮ",
        "Изилдоо жетекчиси": "Изилдөө жетекчиси",
        "болуктору": "бөлүктөрү",
        "баштапкы көрсөткүч": "базалык эвристика",
        "базис үчтөн бирин": "базалык эвристика үчтөн бирин",
        "прецизиясы": "тактык көрсөткүчү",
    }
    for paragraph in document.paragraphs:
        text = paragraph.text
        new_text = text
        for old, new in replacements.items():
            new_text = new_text.replace(old, new)
        if new_text != text:
            paragraph.text = new_text


def add_inline_citations(document: Document, max_total: int = 120) -> int:
    try:
        literature_index = find_index(document, "ПАЙДАЛАНЫЛГАН АДАБИЯТТАР")
    except ValueError:
        literature_index = len(document.paragraphs)

    added = 0
    section_counts: dict[str, int] = {}
    current_section = ""
    for index, paragraph in enumerate(document.paragraphs[:literature_index]):
        text = paragraph.text.strip()
        if not text:
            continue
        if is_heading(text):
            current_section = text[:40]
            section_counts.setdefault(current_section, 0)
            continue
        citation = citation_for(text)
        if citation is None:
            continue
        count = section_counts.get(current_section, 0)
        if added >= max_total:
            break
        if count >= 4:
            continue
        if add_citation_to_paragraph(paragraph, citation):
            added += 1
            section_counts[current_section] = count + 1
    return added


def main() -> int:
    parser = argparse.ArgumentParser(description="Add academic citation style to the Kyrgyz dissertation.")
    parser.add_argument("--source", default=SOURCE_DOCX)
    parser.add_argument("--output", default="scripts/out/Конечный_дисс_cited_polished.docx")
    args = parser.parse_args()

    document = Document(args.source)
    normalize_kyrgyz_terms(document)
    added = add_inline_citations(document)
    replace_literature(document)

    output = Path(args.output)
    output.parent.mkdir(parents=True, exist_ok=True)
    document.save(output)
    print(f"Citations added: {added}")
    print(f"Output: {output.as_posix()}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
