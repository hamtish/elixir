defmodule Exam do

# Implementera en funktion, toggle/1 som tar en lista och returnerar
# en lista där element har bytt plats två-och-två. Om antalet element
# är udda så lämnas det sista elementet på sin plats.

def toggle([a,b|rest]) do [b, a | toggle(rest)] end
def toggle(rest) do rest end

# Implementera en stack: föreslå en lämplig datastruktur och implementera sedan
# funktionerna push/2 och pop/1. Funktionen push/2 skall returnera den uppdaterade
# stacken och pop/1 skall returnera antingen {:ok, any(), stack()} om det finns
# ett element på stacken eller :no om stacken är tom.

def push(stack, elem) do [elem|stack] end
def pop([]) do :no end
def pop([elem|res]) do {:ok, elem, res} end

# Implementera en funktion flatten/1 som tar en lista av listor, som in sin tur
# kan vara listor av listor osv, och returnera en platt lista av alla element av
# de som finns in den urspungliga listan i samma ordning. Du kan använda ++ för
# att slå ihop två listor.

def flatten([]) do [] end
def flatten([head|tail]) do flatten(head) ++ flatten(tail) end
def flatten(item) do [item] end

# Ett h-värde kan används för att beskriva hur mycket och långt man springer.
# Ditt h-värde är det högsta tal h där du sprungit åtminstone h km åtminstone
# h gånger. Ditt h-värde är till exempel 12 om du sprungit 12 km eller längre
# 16 gånger men inte sprungit 13 km eller längre åtminstone 13 gånger. Det är
# relativt enkelt att komma upp i ett h-värde på tio, men lite tuffare att
# komma upp i 30. Implementera en funktion index/1 som givet en lista av tal
# som anger löp- sträckor, räknar ut en löpares h-värde. Listan av löpsträckor
# kommer att vara ordnad med de längsta sträckorna först. Du kommer kunna räkna
# ut resultatet utan att behöva gå igenom listan flera gånger. Algoritmen är enkel:
# - Den initiala uppskattningen av det sökta h-värdet är 0.
# - Gå igenom listan och om nästa värde är högre än din nuvarade uppskattning,
#   - så räkna upp uppskattingen med 1 och fortsätt annars,
#   - så har du hittat det sökta h-värdet.
# Exempel: index([12,10,8,8,6,4,4,4,2]) skall returnera: 5

def index(runs) do index(runs, 0) end
  def index([k|rest], n) when k > n do
    index(rest, n+1)
  end
def index(_, n) do n end

# Implementera en funktion compact/1 som tar ett träd på formen nedan och
# returnerar ett träd där en nod med samma nycklar i sina två löv (eller om
# det bara finns ett löv), ersätts med ett löv. Funktionen skall fungera
# rekursivt så att ändringar propagerar mot roten. Träden är representerade
# enligt följande, notera att vi endast har värden i löven:
# @type tree() :: :nil | {:node, tree(), tree()} | {:leaf, any()}
# Exempel:
# compact({:node, {:leaf, 4}, {:leaf, 4}})
# - Skall returnera: {:leaf, 4}
# compact({:node, {:leaf, 5}, {:node, :nil, {:leaf, 4}}})
# - Skall returnera: {:node, {:leaf, 5}, {:leaf, 4}}

def compact(:nil) do :nil end
def compact({:leaf, value}) do {:leaf,value} end
def compact({:node, left, right}) do
  cl = compact(left)
  cr = compact(right)
  combine(cl, cr)
end
def combine(:nil, {:leaf, value}) do
  {:leaf, value}
end
def combine({:leaf, value}, :nil) do
  {:leaf, value}
end
def combine({:leaf, value}, {:leaf, value}) do
  {:leaf, value}
  end
def combine(left, right) do
  {:node, left, right}
end

# Du skall implementera en function primes/0 som returnerar en funktion som
# representerar en oändlig sekvens av primtal. Funktionen som returneras skall,
# när den appliceras utan argument, returnera en tuple {:ok, prime, next} där
# prime är nästa primtal och next en funktion som representerar resten.
# @type next() :: {:ok, integer(), ( -> next())}
# @spec primes() :: ( -> next())
# Ett sätt att lösa problemet är att implementera Eratosthenes såll. När man har
# hittat ett primtal (det första är 2) så ser man till att inte returnera något
# tal n som är jämt delbart med det primtalet (rem(n, p) == 0). Nedan följer en
# bra start för denna algoritm, det är nu din uppgift att implemetera sieve/2.

def primes() do
  fn() -> {:ok, 2, fn() -> sieve(2, fn() -> next(3) end) end} end
end
def next(n) do
  {:ok, n, fn() -> next(n+1) end}
end

def sieve(p, f) do
  {:ok, n, f} = f.()
  if rem(n, p) == 0 do
    sieve(p, f)
  else
    {:ok, n, fn() -> sieve(n, fn() -> sieve(p, f) end) end}
  end
end

# Om man implementerar flatten/1 på enklast möjliga sätt så får man en algorithm
# som inte har speciellt bra tidskomplexitet. Man kommer att slå ihop listor som
# efter hand blir längre och längre och komlexiteten blir kvadratiskt med avseende
# på antalet element. Du skall nu implementera flatten/1 men se till så att
# komplexiteten blir linjär med avseeden på antalet element i listorna.

def improved([]) do [] end
  def improved([[] | rest]) do
    improved(rest)
  end
  def improved([[head | tail] | rest]) do
    improved([head, tail | rest])
  end
  def improved([ elem | rest]) do
    [elem | improved(rest)]
end

# Du skall implementera en funktion pmap/2 som fungerar som vanliga map/2 men där
# varje element evalueras i en separat process och därmed kan köras parallelt. Du
# skall använda dig av den vanliga map/2 när du startar processer och när du samlar
# ihop resultatet. Exempel: uttrycket nedan
# pmap([1,2,3,4], fn(x) -> x + 2 end)
# - Skall returnera:[3,4,5,6]
def pmap(list, fun) do
  refs = Enum.map(list, parallel(fun))
  Enum.map(refs, collect())
end
def parallel(fun) do
  me = self()
  fn(x) ->
    ref = make_ref()
    spawn(fn() ->
res = fun.(x)
      send(me, {:ok, ref, res})
    end)
ref end
end
def collect() do
  fn(r) -> receive do {:ok, ^r, res} -> res end end
end

# Ta bort alla sekvenser av upprepningar som sker efter varann.
# T.ex. [1,1,2,3,3,4,5,6,7,7,1] returnerar [1,2,3,4,5,6,7,1]
def reduce([]) do ([]) end
def reduce([h, h|t]) do reduce([h|t]) end
def reduce([h|t]) do [h|reduce(t)] end

# Räknar ut summan av talen i en lista samt antalet tal i listan.
# T.ex. [1,2,3] returnerar {6,3} där 6 är summan och 3 antalet tal.
def once([]) do {0,0} end
def once([h|t]) do
  {x,y} = once(t)
  {x+h,y+1}
end

# Ackermann-funktionen enl. definition (se Wiki)
def ack(0,n) do n+1 end
def ack(m,0) do ack(m-1, 1) end
def ack(m,n) do ack(m-1, ack(m, n-1)) end

# Returnerar true eller false beroende på om dess två argument
# är isomorfa eller inte.
def isomorfic(nil, nil) do true end
def isomorfic({tree, _, L1, R1}, {tree, _, L2, R2}) do
   case isomorfic(L1, L2) do
       true -> isomorfic(R1, R2)
       false -> false
   end
end
def isomorfic(_, _) do false end

# Funktion som tar ett träd och returnerar det spegelvända trädet.
def mirror(nil) do nil end
def mirror({tree, val, left, right}) do {tree, val, mirror(right), mirror(left)} end

# Svansrekursiv funktion som summerar alla element i en lista.
def sum(k) do sum(k, 0) end
def sum([], s) do s end
def sum([h|t], s) do sum(t, h+s) end

# Funktion som tar ett träd & returnerar summan av alla värden i trädet.
def zum(nil) do 0 end
def zum({:node, v, left, right}) do
  v + zum(left) + zum(right)
end

# Den normala definitionen av append/2 är inte svansrekursiv. Implementera
# funktionen reverse/1 svansrekursivt och använd den för att implementerar
# append/2 svansrekursivt.
def reverse(a) do reverse(a, []) end
def reverse([], b) do b end
def reverse([h|t], b) do
  reverse(t, [h|b])
end
def append(a, b) do reverse(reverse(a), b) end

# Lägga till och ta bort element ur en kö
def enque({:queue, head, tail}, elem) do
  {:queue, head, [elem|tail]}
end
def dequeu({:queue, [], []}) do :fail end
def dequeu({:queue, [elem|head], tail}) do
  {:ok, elem, {:queue, head, tail}}
end
def dequeu({:queue, [], tail}) do
  dequeu({:queue, reverse(tail), []})
end

# Funktion ssum/1 som tar ett binärt träd med tal i löven och summerar
# alla talen i trädet parallelt.
def ssum({:leaf, n}) do n end
def ssum({:node, left, right}) do
  self = self()
  spawn(fn() -> n = ssum(left); send(self, n) end)
  spawn(fn() -> n = ssum(right); send(self, n) end)
  receive do
      n1 ->
      receive do
        n2 -> n1 + n2
      end
  end
end

# Implementera funktionen popz/1 som plockar ut det högsta elementet ur en heap
# och returnerar antingen :fail, om heapen är tom, eller {:ok, integer(), heap()}
def popz(nil) do :fail end
def popz({:heap, k, left, nil})  do
  {:ok, k, left}
end
def popz({:heap, k, nil, right})  do
  {:ok, k, right}
end
def popz({:heap, k, left, right})  do
  {:heap, l, _, _} = left
  {:heap, r, _, _} = right
  if l < r do
    {:ok, _, rest} = popz(right)
    {:ok, k, {:heap, r, left, rest}}
  else
    {:ok, _, rest} = popz(left)
    {:ok, k, {:heap, l, rest, right}}
  end
end

# Implementera funktionen swap/2 som tar en heap och ett tal och returnerar
# {:ok, integer(), heap()} där talet är det högsta talet och heapen den resterande
# heapen. Funktionen skall ha samma betydelse som att först göra add/2 på talet
# och sen göra pop/1 för att ta ut det högsta elementet men vi skall göra detta
# i en funktion, inte anropa de båda funktionerna.
def swap(nil, v) do
  {:ok, v, nil}
end
def swap({:heap, k, left, right}, v) when k > v do
  {:ok, v, left} = swap(left, v)
  {:ok, v, right} = swap(right, v)
  {:ok, k,  {:heap, v, left, right}}
end
def swap(heap, v) do
  {:ok, v,  heap}
end

# Vi skall implementera en funktion fizzbuzz/1 som givet ett tal n ≥ 0
# returnerar en lista av de n första elementen i fizzbuzz-serien. Fizz-Buzz
# går till så att man räknar från 1 till n men byter ut all tal som är delbara
# med 3 mot :fizz, alla tal som är delbara med 5 med :buzz och all tal som är
# delbara med både 3 och 5 mot :fizzbuzz. De första fem elementen är således:
# [1,2,:fizz,4,:buzz].

def fizzbuzz(n) do fizzbuzz(1, n+1, 1, 1) end
def fizzbuzz(n, n, _, _) do [] end
def fizzbuzz(i, n, 3, 5) do [:fizzbuzz | fizzbuzz(i+1, n, 1, 1)] end
def fizzbuzz(i, n, 3, b) do [:fizz | fizzbuzz(i+1, n,   1, b+1)] end
def fizzbuzz(i, n, f, 5) do [:buzz | fizzbuzz(i+1, n, f+1,   1)] end
def fizzbuzz(i, n, f, b) do [i | fizzbuzz(i+1, n, f+1, b+1)] end

# Implementera en funktion, decodez/1 som tar en kodad sekvens och returnerar
# den avkodade sekvensen. En kodad sekvens är representerad som en lista av
# tupler {char, n} där char är ett element i den avkodade sekvensen och n
# antalet förekomster av elementet i följd.
# Exempel: decode([{:a, 2}, {:c, 1}, {:b, 3}, {:a, 1}]) skall ge svaret:
# [:a, :a, :c, :b, :b, :b, :a].
def decodez([]) do [] end
def decodez([{elem, 0}|code]) do
  decodez(code)
end
def decodez([{elem, n}|code]) do
  [elem | decodez([{elem, n-1} | code])]
end

# Implementera en funktion zip/2 som tar två listor, x och y, av samma längd
# och returnerar en lista där det i:te elementet är en tuple, {xi, yi}, av de
# i:te elementen i de båda listorna. Exempel:
# zip([:a,:b,:c], [1,2,3]) returnerar [{:a,1}, {:b,2}, {:c,3}].
def zip([], []) do [] end
def zip([xi|xs], [yi|ys]) do
[{xi,yi}|zip(xs, ys)]
end

# Implementera funktionen eval/1 som tar ett aritmetiskt uttryck och re-turnerar
# dess värde. Exempel: anropet eval({:add, {:mul, 2, 3}, {:neg, 2}}) skall
# returnera 4 eftersom 2 * 3 + (−2) = 4. Vi har givet enl. uppgift:
# @spec expr() :: integer() |
#               {:add, expr(), expr()} |
#               {:mul, expr(), expr()} |
#               {:neg, expr()}
def eval({:add, x, y}) do
  eval(x) + eval(y)
end
def eval({:mul, x, y}) do
  eval(x) * eval(y)
end
def eval({:neg, x}) do
  - eval(x)
end
def eval(x) do
  x
end

# Implementera en funktion gray/1 som tar ett argument n, ett tal större eller
# lika med noll, och genererar en lista av s.k. Gray-koder för bitsekvenser av
# längd n. T.ex. så returnerar gray(3) listan av alla möjliga bitsekvenser.
def gray(0) do [[]] end
def gray(n) do
  g1 = gray(n-1)
  r1 = reverse(g1)
  append(update(g1, 0), update(r1, 1))
end
def update([], _) do [] end
def update([h|t], b) do
  [[b|h]| update(t,b)]
end

# Funktionen fac/1, som returnerar fakulteten (n!) av ett tal n.
def fac(1) do 1 end
def fac(n) do
  n * fac(n-1)
end

# Funktion facl/1 som tar ett tal, n större än noll, och returnerar
# en lista av tal [n!, (n-1)!, ... 1]
def facl(1) do [1] end
def facl(n) do
  rest = facl(n-1)
  [f| _] = rest
  [n*f| rest]
end

# Implementera en funktion, drop/2 som tar en lista och ett tal n > 0, och
# returnerar en lista där var n:te element har plockats bort. Exempel:
# drop([:a,:b,:c,:d,:e,:f,:g,:h,:i,:j], 3) ger oss [:a,:b,:d,:e,:g,:h,:j]
def drop(list, n) do drop(list, n, n) end
  def drop([], _, _) do [] end
  def drop([_|rest], 1, n) do
    drop(rest, n, n)
  end
  def drop([elem|rest], i, n) do
    [elem | drop(rest, i-1, n)]
end

# Implementera en funktion rotate/2 som tar en lista, av längd l, och ett tal
# n, där 0 ≤ n ≤ l, och returnerar en lista där elementen roterat n steg. Du
# kan använda dig av två biblioteksfunktioner: append/2 och reverse/1 (inte ++).
# Din lösning får dock bara använda dessa funktioner en gång vardera under en
# evaluering. Exempel: rotate([:a,:b,:c,:d,:e], 2) returnerar [:c,:d,:e,:a,:b].
def rotate(list, n) do rotate(list, n, []) end
  def rotate(rest, 0, first) do
    append(rest, reverse(first))
  end
  def rotate([elem|rest], n, first) do
    rotate(rest, n-1, [elem|first])
  end

# Funktionen följer HP35-kalkylatorn som utgår från polsk notation, varje gång
# man skriver in ett tal läggs det in på stacken. Funktionen tar en sekvens av
# instruktioner och returnerar resultatet. Anropet hp([3, 4, :add, 2, :sub])
# skall returnera 5 eftersom (3 + 4) − 2 = 5.
def hp(seq) do hp(seq, []) end
def hp([], [res| _]) do res end
def hp([:add|rest], [a, b | stack]) do
  hp(rest, [a+b|stack])
end
def hp([:sub|rest], [a, b | stack]) do
  hp(rest, [b-a|stack])
end
def hp([val|rest], stack) do
  hp(rest, [val|stack])
end

# Given a list and a function, apply the function to each list item and
# replace it with the function's return value.
# Examples:
# iex> Accumulate.accumulate([], fn(x) -> x * 2 end)
# Returns: []
# iex> Accumulate.accumulate([1, 2, 3], fn(x) -> x * 2 end)
# Returns: [2, 4, 6]

def accumulate([], _) do # Basecase.
[]
end
def accumulate([h|t], fun) do # Recursion on the tail.
[fun.(h)| accumulate(t, fun)]
end

@doc """
  Create a new Binary Search Tree with root's value as the given 'data'
  """
  def new(data) do
    %{data: data, left: nil, right: nil}
  end

  @doc """
  Creates and inserts a node with its value as 'data' into the tree.
  """
  def insert(nil,data) do
    new(data)
  end

  def insert(tree, data) do
    cond do
      data <= tree.data ->
        %{tree | left: insert(tree.left, data)}

      data > tree.data ->
        %{tree | right: insert(tree.right,data)}
    end
  end

  @doc """
  Traverses the Binary Search Tree in order and returns a list of each node's data.
  """
  def in_order(tree) do
    create_tree(tree)
  end

  defp create_tree(tree) when tree == nil do
    []
  end

 defp create_tree(tree) do
  create_tree(tree.left) ++ [tree.data] ++ create_tree(tree.right)
  end

  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t()
  def convert(number) do
    cond do
      pling?(number) and plang?(number) and plong?(number) -> "PlingPlangPlong"
      pling?(number) and plang?(number) -> "PlingPlang"
      pling?(number) and plong?(number) -> "PlingPlong"
      plang?(number) and plong?(number) -> "PlangPlong"
      pling?(number) -> "Pling"
      plang?(number) -> "Plang"
      plong?(number) -> "Plong"
      true -> Integer.to_string(number)
    end
  end

  defp pling?(number) do
    rem(number,3) == 0
  end

  defp plang?(number) do
    rem(number,5) == 0
  end

  defp plong?(number) do
    rem(number,7) == 0
  end

  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RNATranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
    Enum.map(dna, &transcription/1)
  end

  defp transcription(nucleotide) do
   case nucleotide do
     ?G -> ?C
     ?C -> ?G
     ?T -> ?A
     ?A -> ?U
   end
 end

 @doc """
  Convert the number to a roman number.
  """

  @roman [
    {1000, "M"},
    {900, "CM"},
    {500, "D"},
    {400, "CD"},
    {100, "C"},
    {90, "XC"},
    {50, "L"},
    {40, "XL"},
    {10, "X"},
    {9, "IX"},
    {5, "V"},
    {4, "IV"},
    {1, "I"}
  ]

  @spec numerals(pos_integer) :: String.t()
  def numerals(number) do
    numerals(@roman, number, "")
  end

  defp numerals(_, 0, tail) do
     tail
  end

  defp numerals([{x,y}|_] = roman, number, tail) when number >= x do
      numerals(roman, number - x, tail <> y)
  end

  defp numerals([_|t], number, tail) do
      numerals(t, number, tail)
  end

@doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    cleaned_sentence = clean(sentence)
    count(String.split(cleaned_sentence), %{})
  end

  defp count([], result) do
    result
  end

  defp count([head|tail], result) do
    new_result = Map.update(result, head, 1, &(&1 + 1))
    count(tail, new_result)
  end

  defp clean(input) do
    input |> String.replace(~r/[^\p{L}\d-]/u, " ") |> String.trim |> String.downcase
  end

end
