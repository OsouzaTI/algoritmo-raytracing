include("../../vector/vector.jl")

u = vec3(1, 2, 3)
v = vec3(3, 2, 1)
println("resultante -> ", dot(u, v))
u_unitario = normalize(u)
println("vetor u : ", u, " | unitario(u) -> ", u_unitario)
println("Norma de unitario(u) : ", norma(u_unitario))