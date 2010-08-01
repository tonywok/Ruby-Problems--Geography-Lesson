class Geo
  
  def get_xy latlong
    latlong = latlong.split(/\s/)
    xy = separate(latlong).inject([]) do |xy, coordinate|
      points = (compute_accuracy(coordinate) + 
                coordinate.reject! {|direction| direction !~ /[NSEW]/}).join(' ')
      points = '-' << points if points =~ /[SW]/
      xy << points.gsub(/[NSEW+\s]/, "").to_f
    end.reverse
  end

  def separate latlong
    return latlong.slice(0, latlong.length/2), 
           latlong.slice(latlong.length/2, latlong.length)
  end

  def compute_accuracy(coordinate, total=0)
    coordinate.reject { |direction| direction =~ /[NSEW]/ }.each_with_index do |degree, i|
      total += degree.to_f.abs/(60**i)
    end
    [coordinate.to_s =~ /[-]/ ? total*-1.0 : total]
  end

end
