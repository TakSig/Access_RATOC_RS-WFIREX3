#
# A ruby code to access RATOC System RS-WFIREX3
# to read temperature, relative humidity, and illuminance
#
# https://iot.ratocsystems.com/products/rs-wfirex3/
#
# TakaShiga
#

require 'socket'

def get_RS_WFIREX3(ip)
  begin
    temp, rh, lux = TCPSocket.open(ip, 60001) { |socket|
      socket.puts "\xAA\x00\x01\x18\x50"
      res  = socket.gets.to_s.unpack("H*").to_s
      temp = res[14,4].to_s.to_i(16)/10.0
      rh   = res[10,4].to_s.to_i(16)/10.0
      lux  = res[18,4].to_s.to_i(16)
      [ temp, rh, lux ]
    }
  rescue Exception => exc
    $stderr.puts exc
    temp = nil
    rh   = nil
    lux  = nil
  end
  [ temp, rh, lux ]
end


# call with IP address of RS-WFIREX3 at your environment
ip = "192.168.1.***"

temp, rh, lux = get_RS_WFIREX3(ip)

puts "temperature:   #{temp} deg.C"
puts "rel. humidity: #{rh} %"
puts "illuminance:   #{lux} lx"

