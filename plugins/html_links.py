# From <https://datasette.readthedocs.io/en/stable/plugins.html#render-cell-value-column-table-database-datasette>
from datasette import hookimpl
import jinja2
import json


@hookimpl
def render_cell(value):
    """
    Render ``{"href": "...", "label": "..."}`` as a link.
    """
    if not isinstance(value, str):
        return None

    stripped = value.strip()

    if not stripped.startswith("{") and stripped.endswith("}"):
        return None

    try:
        data = json.loads(value)
    except ValueError:
        return None

    if not isinstance(data, dict):
        return None

    if set(data.keys()) != {"href", "label"}:
        return None

    href = data["href"]

    if not (
        href.startswith("/") or href.startswith("http://")
        or href.startswith("https://")
    ):
        return None

    return jinja2.Markup('<a href="{href}">{label}</a>'.format(
        href = jinja2.escape(data["href"]),
        label = jinja2.escape(data["label"] or "") or "&nbsp;"
    ))
