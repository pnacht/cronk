import json
from typing import List

from loguru import logger

from cronk.json_routine import Json, Routine


def json_to_cron(text: str) -> List[str]:
    # logger.debug(f"Converting json file to cron format")

    if not isinstance(text, str):
        raise TypeError("Must be str type")

    js = _to_Json(json.loads(text))

    output = js.intro

    if not js.routines:
        return output

    output.append("")  # blank line between intro and first command

    output.extend(_routine_to_cron(js.routines))
    output.extend(js.outro)

    return output


def _routine_to_cron(routines: List[Routine]) -> List[str]:
    return [
        s
        for routine in routines
        for s in routine.comments + [routine.time + " " + routine.command]
    ]


def _to_Json(json: dict) -> Json:
    try:
        output = Json(
            intro=json["intro"],
            routines=[
                Routine(comments=r["comments"], command=r["command"])
                for r in json["routines"]
            ],
            outro=json["outro"],
        )
    except (KeyError, TypeError):
        raise ValueError("JSON file must satisfy schema defined in schema.json.")

    return output
