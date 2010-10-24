%w{ method_extensions }.each do |g|
  require g
end

%w{ application }.each do |f|
  require File.join('cans', f)
end

module Cans

end
