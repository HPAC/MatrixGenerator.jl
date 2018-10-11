using DelimitedFiles
include("Results.jl")

mutable struct Plot

  file::IOStream
  delimiter::Char

  """
  #Arguments
  * name - filename
  * labels - labels for additional user-defined columns
  * delimiter - 
  """
  function Plot(name::String, labels::Array{String, 1} = Array{String, 1}(), delimiter::Char = '\t') where T

    f = open(name, "w")
    full_labels = ["Time" "StdDev" "Min" "Max"]
    if !isempty(labels)
      full_labels = hcat(permutedims(hcat(labels), [2, 1]), full_labels)
    end
    writedlm(f, full_labels, delimiter)
    return new(f, delimiter)
  end
end

"""
  Add another timings to data file
"""
function add_data(p::Plot, timings::Results)

  t = [timings.average_time timings.std_dev timings.min_time timings.max_time]
  writedlm(p.file, t, p.delimiter)
end

"""
  Add a timings preceded by additonal user-defined columns
"""
function add_data(p::Plot, data::Array{P, 1}, timings::Results) where P

  t = [timings.average_time timings.std_dev timings.min_time timings.max_time]
  data_to_write = [reshape(data, (1, :)) t]
  writedlm(p.file, data_to_write, p.delimiter)
end

function finish(p::Plot)
  close(p.file)
end
