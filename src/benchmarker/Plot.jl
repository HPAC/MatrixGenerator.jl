##############
#    Plot    #
##############

mutable struct Plot
  file::IOStream
  file_timings::IOStream
  delimiter::Char
end

function Plot(name::String, extra_labels::Array{String, 1} = Array{String, 1}(), delimiter::Char = '\t')
  labels = ["Time" "StdDev" "Min" "Max"]
  labels = isempty(extra_labels) ? labels : [reshape(extra_labels, (1, :)) labels]

  f = open(string(name,".txt"), "w")
  writedlm(f, labels, delimiter)

  ft = open(string(name,"_timings.txt"), "w")
  return Plot(f, ft, delimiter)
end

function add_data(p::Plot, extra_data::Array{P, 1}, timings::Results) where P
  t = [timings.average_time timings.std_dev timings.min_time timings.max_time]
  data = isempty(extra_data) ? t : [reshape(extra_data, (1, :)) t]
  writedlm(p.file, data, p.delimiter)

  t = transpose(timings.timings)
  data = isempty(extra_data) ? t : [reshape(extra_data, (1, :)) t]
  writedlm(p.file_timings, data, p.delimiter)
end

function finish(p::Plot)
  close(p.file)
  close(p.file_timings)
end
