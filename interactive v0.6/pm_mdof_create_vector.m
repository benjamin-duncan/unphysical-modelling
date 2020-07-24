function [vector]=pm_mdof_create_vector(value,dofs)

    vector = value * ones(1,dofs)
end