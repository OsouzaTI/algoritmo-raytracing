abstract type Material end

struct Metal <: Material
    albedo::RGB
end

struct Lambertian <: Material
    albedo::RGB
end
