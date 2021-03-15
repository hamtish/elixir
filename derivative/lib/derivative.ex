defmodule Derivative do
  def main() do
    f = {:add, {:mul, {:num, 3}, {:var, :x}}, {:exp, {:var, :x}, {:num, 5}}}
    fp = deriv(f, :x)

    IO.write("#{pprint(fp)}\n")
    fp = simplify(fp)
    IO.write("#{pprint(fp)}\n")
  end

  def deriv({:num, _}, _) do {:num, 0} end
  def deriv({:var, v}, v) do {:num, 1} end
  def deriv({:var, _}, _) do {:num, 0} end
  def deriv({:mul, e1, e2}, v) do {:add, {:mul, deriv(e1, v), e2}, {:mul, e1, deriv(e2, v)}} end
  def deriv({:add, e1, e2}, v) do {:add, deriv(e1, v), deriv(e2, v)} end
  def deriv({:exp, {:num, _}, {:num, _}}, _) do {:num, 0} end
  def deriv({:exp, {:var, e}, {:num, n}}, x) do
    cond do
      e != x -> {:num, 0}
      true -> {:mul, {:num, n}, {:exp, {:var, e}, {:num, n-1}}}
    end
  end

  def simplify({:add, e1, e2}) do simplify_add(simplify(e1), simplify(e2)) end
  def simplify({:mul, e1, e2}) do simplify_mul(simplify(e1), simplify(e2)) end
  def simplify({:exp, e1, e2}) do simplify_exp(simplify(e1), simplify(e2)) end
  def simplify(e) do e end

  def simplify_add(e, {:num, 0}) do e end
  def simplify_add({:num, 0}, e) do e end
  def simplify_add({:num, n1}, {:num, n2}) do {:num, n1 + n2} end
  def simplify_add({:var, e}, {:var, e}) do {:mul, {:num, 2}, {:var, e}} end
  def simplify_add(e1, e2) do {:add, e1, e2} end

  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(_, {:num, 0}) do {:num, 0} end
  def simplify_mul({:num, 1}, e) do e end
  def simplify_mul(e, {:num, 1}) do e end
  def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end
  def simplify_mul(e1, e2) do {:mul, e1, e2} end

  def simplify_exp(_, {:num, 0}) do {:num, 1} end
  def simplify_exp(e, {:num, 1}) do e end
  def simplify_exp({:num, n1}, {:num, n2}) do {:num, :math.pow(n1, n2) |> round} end
  def simplify_exp(e1, e2) do {:exp, e1, e2} end

  #### printing
  def pprint({:num, n}) do "#{n}" end
  def pprint({:var, x}) do "#{x}" end
  def pprint({:add, e1, e2}) do "(#{pprint(e1)} + #{pprint(e2)})" end
  def pprint({:mul, e1, e2}) do "#{pprint(e1)}*#{pprint(e2)}" end
  def pprint({:exp, e1, e2}) do "#{pprint(e1)}^(#{pprint(e2)})" end
end
