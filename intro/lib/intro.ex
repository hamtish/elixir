defmodule Intro do
## Returns m * n
def product(m, n) do
  case m do
    0 ->
       0
    _ ->
      product(m - 1, n) + n
  end
end

## Returns x^n
def exp(x, n) do
  case n do
    0 ->
      1
    1 ->
      x
    _ ->
      product(x, exp(x, n-1))
  end
end

## Returns nth element of list assuming first element has index 1
def nth(n, [h|t]) do
  case n do
    1 ->
      h
    _ ->
      nth(n - 1, t)
  end
end

## Returns length of list
def len([]) do 0 end
def len([_|t]) do
  1 + len(t)
end

## Returns sum of all elements in list
def sum([]) do 0 end
def sum([h|t]) do
  h + sum(t)
end

## Duplicates every element in list

def duplicate(l) do
  cond do
    l == [] ->
      []
    true ->
      [hd(l), hd(l)|duplicate(tl(l))]
  end
end

## Adds element x in list if x isnt in list already

def add(x, l) do
  if x != hd(l) do
    cond do
      tl(l) == [] ->
        [x]
      true ->
        [hd(l)|add(x, tl(l))]
    end
  else
    IO.puts("Already in list")
  end
end

## Removes all occurences of element x from list
def remove(x,l) do
  cond do
    l == [] ->
      []
    x == hd(l) ->
      remove(x,tl(l))
    true ->
      [hd(l)|remove(x,tl(l))]
  end
end
end
