name "kontena-cli"
default_version File.read('../VERSION').strip
source path: "./wrappers"
dependency "ruby"
dependency "rubygems"
dependency "libxml2"
dependency "libxslt"
whitelist_file "./wrappers/sh/kontena"
build do
  gem "install nokogiri -v 1.6.8 --no-ri --no-doc"
  gem "install kontena-cli -v #{default_version} --no-ri --no-doc"
  copy "sh/kontena", "#{install_dir}/bin/kontena"
end
