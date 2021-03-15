defmodule Binarytree do
  # Checks if element is in binary tree
  # Checks leafs
  @spec member(any, nil | {:leaf, any} | {:node, any, any, any}) :: :no | :yes
  def member(_, :nil) do :no end
  def member(elem, {:leaf, elem}) do :yes end
  def member(_, {:leaf, _}) do :no end

  # Checks nodes
  def member(elem, {:node, elem, _, _}) do :yes end
  def member(elem, {:node, value, left, right}) do
    cond do
      elem < value ->
        member(elem, left)
      true ->
        member(elem, right)
    end
  end

  # Inserts new element in to binary tree
  def insert(elem, :nil) do {:leaf, elem} end
  def insert(elem, {:leaf, v}) do
    cond do
      elem < v ->
        {:node, v, {:leaf, elem}, :nil}
      true ->
        {:node, v, :nil, {:leaf, elem}}
    end
  end
  def insert(elem, {:node, v, left, right}) do
    cond do
      elem < v ->
        {:node, v, insert(elem, left), right}
      true ->
        {:node, v, left, insert(elem, right)}
    end
  end

  # Deletes element from binary tree (naive solution)
  def delete(elem, {:leaf, elem}) do :nil end
  def delete(elem, {:node, elem, left, :nil}) do left end
  def delete(elem, {:node, elem, :nil, right}) do right end
  def delete(elem, {:node, elem, left, right}) do {:node, getval(right), left, delete(getval(right), right)} end
  def delete(elem, {:node, v, left, right}) do
    cond do
      elem < v ->
        {:node, v, delete(elem, left), right}
      true ->
        {:node,  v, left, delete(elem, right)}
    end
  end

  # Returns value of leaf or node
  def getval({:leaf, val}) do val end
  def getval({:node, val, _, _}) do val end
end

defmodule Bst do
  #### BINARY SEARCH TREE ####

  def add(key, elem, :nil) do {:node, key, elem, :nil, :nil} end
  def add(key, elem, {:node, key, _, left, right}) do {:node, key, elem, left, right} end
  def add(key, elem, {:node, k, v, left, right}) do
    cond do
      key < k ->
        {:node, k, v, add(key, elem, left), right}
      true ->
        {:node, k, v, left, add(key, elem, right)}
    end
  end

  # Returns value associated with key, if it doesnt exist returns :no
  def lookup(key, {:node, key, v, _, _}) do {:ok, v} end
  def lookup(key, {:node, k, _, left, right}) do
    cond do
      key < k -> lookup(key, left)
      true -> lookup(key, right)
    end
  end
  def lookup(_, _) do :no end

  # Remove key-value pair
  def remove(key, {:node, key, _, :nil, :nil}) do :nil end
  def remove(key, {:node, key, _, left, :nil}) do left end
  def remove(key, {:node, key, _, :nil, right}) do right end
  def remove(key, {:node, key, _, left, right}) do
    {:node, getkey(right), getval(right), left, remove(getkey(right), right)}
  end
  def remove(key, {:node, k, v, left, right}) do
    cond do
      key < k ->
        {:node, k, v, remove(key, left), right}
      true ->
        {:node, k, v, left, remove(key, right)}
    end
  end

  def getval({:node, _, v, _, _}) do v end
  def getkey({:node, key, _, _, _}) do key end
end
