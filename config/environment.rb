
# Load the rails application
require File.expand_path('../application', __FILE__)

# fix problem with rubygems 1.5 and higher
# PS: 1.5 switches YAML engine which crashes on <<: in YAML config
YAML::ENGINE.yamler= 'syck' 

# Initialize the rails application
Icanhazblog::Application.initialize!
