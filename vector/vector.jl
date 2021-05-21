# nomeclatura de vec3 -> array[tipo, dimensão]
const vec3{T <: Real} = Array{T, 1}

function vec3{T}(x::T, y::T, z::T) where T
    [x, y, z]
end

# construtor menos burocrático
function vec3(x::T, y::T, z::T) where T
    vec3{T}(x, y, z)
end

function norma(u::vec3)
    # Dado um conjunto de R3:
        # u = (3.0, 4.0, 5.0)
    # sera usado o metodo 'map' em todos os elementos
    # os transformando em potência de 2 e logo apos
    # será realizada o somatório de todos os elementos
    # que por fim serão extraidos pela raiz.

    # mesmo que:
        # sqrt(u.x^2 + u.y^2)

    √sum(map(e -> e^2, u))
end

function normasquare(u::vec3)
    # retorno da norma na potência de 2
    norma(u)^2
end

function dot(u::vec3, v::vec3)
    # produto vetorial é dado pelo somatorio do 
    # produto termo a termo das componentes dimensão
    # vetores

    # será realizada um produtorio de u com v, ou seja,
    # se u = (1, 2, 3) e v = (3, 2, 1)
    # resultado = (u.x * v.x) + (u.y * v.y) + (u.z * v.z)
    
    # u .* v -> (1 * 3, 2 * 2, 3 * 1) -> (3, 4, 3)
    # sum( (3, 4, 3) ) -> 3 + 4 + 3 -> 10

    sum(u .* v)
end

function normalize(u::vec3)
    u / norma(u)
end
