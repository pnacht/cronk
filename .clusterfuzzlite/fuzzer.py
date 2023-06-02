import sys

import atheris
from hypothesis import given
from hypothesis import strategies as st

from cronk import cron_to_json, json_to_cron

JSON_ATOMS = st.one_of(
    st.none(),
    st.booleans(),
    st.integers(min_value=-(2**63), max_value=2**63 - 1),
    st.floats(allow_nan=False, allow_infinity=False),
    st.text(),
)
JSON_OBJECTS = st.recursive(
    base=JSON_ATOMS,
    extend=lambda inner: st.lists(inner) | st.dictionaries(st.text(), inner),
)


@given(json=JSON_OBJECTS)
@atheris.instrument_func
def test_json_to_cron_to_json_roundtrip(json: str) -> None:
    cron_text = "\n".join(json_to_cron(text=json))
    output = cron_to_json(text=cron_text)
    assert json == output


if __name__ == "__main__":
    # Running this function will replay, deduplicate, and minimize any failures
    # discovered by earlier runs, or briefly search for new failures if none are known.
    atheris.Setup(
        sys.argv,
        atheris.instrument_func(
            test_json_to_cron_to_json_roundtrip.hypothesis.fuzz_one_input
        ),
    )
    atheris.Fuzz()
