
# log pdf for commonly used distributions

doc"""
    log_unifpdf(x::Real, a::Real,b::Real)

Computes log(unifpdf(x,a,b)).
"""
function log_unifpdf(x::Real, a::Real, b::Real)

  if  x >= a && x<= b
    return -log(b-a)
  else
    return log(0)
  end

end

# add more distributions here
