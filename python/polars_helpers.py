from __future__ import annotations

from typing import Union
import polars as pl


def agg_multiple(
    cols: Union[str, list[str]], funcs: Union[str, list[str]]
) -> list[pl.Expr]:
    if isinstance(cols, str):
        cols = [cols]
    if isinstance(funcs, str):
        funcs = [funcs]

    exprs = []
    for col in cols:
        for func in funcs:
            exprs.append(getattr(pl.col(col), func)().alias(f"{col}_{func}"))

    return exprs
