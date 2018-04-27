
doc"""
    Euclidean(s_star::Vector, s::Vector, w::Vector)

The (weigthed) Euclidean distance function.
"""
function Euclidean(s_star::Vector, s::Vector, w::Vector)

  Δs =  (s_star-s)
  dist = Δs'*inv(diagm(w.^2))*Δs
  return sqrt(dist[1])

end

# add more distance functions here
