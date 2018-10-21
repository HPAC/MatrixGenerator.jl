##############
#    Plot    #
##############

mutable struct Plot
  file::IOStream
  delimiter::Char
end

function Plot(name::String, extra_labels::Array{String, 1} = Array{String, 1}(), delimiter::Char = '\t')
  labels = ["Time" "StdDev" "Min" "Max"]
  labels = isempty(extra_labels) ? labels : [reshape(extra_labels, (1, :)) labels]

  f = open(name, "w")
  writedlm(f, labels, delimiter)
  return Plot(f, delimiter)
end

function add_data(p::Plot, extra_data::Array{P, 1}, timings::Results) where P
  t = [timings.average_time timings.std_dev timings.min_time timings.max_time]
  data = isempty(extra_data) ? t : [reshape(extra_data, (1, :)) t]
  writedlm(p.file, data, p.delimiter)
end

function finish(p::Plot)
  close(p.file)
end
