source 'http://rubygems.org'

# Local gems are useful when developing and integrating the various dependencies.
# To favor the use of local gems, set the following environment variable:
#   Mac: export FAVOR_LOCAL_GEMS=1
#   Windows: set FAVOR_LOCAL_GEMS=1
# Note that if allow_local is true, but the gem is not found locally, then it will
# checkout the latest version (develop) from github.
allow_local = ENV['FAVOR_LOCAL_GEMS']

# Uncomment the extension, common measures, core gems if you need to test local development versions. Otherwise
# these are included in the model articulation and urbanopt gems
#
# if allow_local && File.exist?('../OpenStudio-extension-gem')
#   gem 'openstudio-extension', path: '../OpenStudio-extension-gem'
# elsif allow_local
#   gem 'openstudio-extension', github: 'NREL/OpenStudio-extension-gem', branch: 'develop'
# end
#
# if allow_local && File.exist?('../openstudio-common-measures-gem')
#   gem 'openstudio-common-measures', path: '../openstudio-common-measures-gem'
# elsif allow_local
#   gem 'openstudio-common-measures', github: 'NREL/openstudio-common-measures-gem', branch: 'develop'
# end
#
# if allow_local && File.exist?('../urbanopt-core-gem')
#   gem 'urbanopt-core', path: '../urbanopt-core-gem'
# elsif allow_local
#   gem 'urbanopt-core', github: 'URBANopt/urbanopt-core-gem', branch: 'develop'
# end
#
# if allow_local && File.exist?('../openstudio-model-articulation-gem')
#   # gem 'openstudio-model-articulation', github: 'NREL/openstudio-model-articulation-gem', branch: 'develop'
#   gem 'openstudio-model-articulation', path: '../openstudio-model-articulation-gem'
# elsif allow_local
#   gem 'openstudio-model-articulation', github: 'NREL/openstudio-model-articulation-gem', branch: 'develop'
# else
#   gem 'openstudio-model-articulation', '0.1.0'
# end
#gem 'urbanopt-scenario', path: '../urbanopt-scenario-gem'
gem 'urbanopt-scenario', github: 'URBANopt/urbanopt-scenario-gem', branch: 'der'

# if allow_local && File.exist?('../urbanopt-scenario-gem')
#   gem 'urbanopt-scenario', path: '../urbanopt-scenario-gem'
# elsif allow_local
#   gem 'urbanopt-scenario', github: 'URBANopt/urbanopt-scenario-gem', branch: 'der'
# else
#   gem 'urbanopt-scenario', '0.1.0'
# end

gem 'urbanopt-reopt', :git => 'https://github.com/urbanopt/urbanopt-reopt-gem.git', :branch => 'initial_measure'

# if allow_local && File.exist?('../urbanopt-reopt-gem')
#   gem 'urbanopt-reopt', path: '../urbanopt-reopt-gem'
# elsif allow_local
#   gem 'urbanopt-reopt', github: 'urbanopt/urbanopt-reopt-gem/', branch: 'initial_measure'
# else
#   gem 'urbanopt-reopt', '0.1.0'
# end


gem 'urbanopt-geojson', github: 'URBANopt/urbanopt-geojson-gem', branch:  'develop'
# if allow_local && File.exists?('../urbanopt-geojson-gem')
#   # gem 'openstudio-extension', github: 'NREL/OpenStudio-extension-gem', branch: 'develop'
#   gem 'urbanopt-geojson', path: '../urbanopt-geojson-gem'
# elsif allow_local
#   gem 'urbanopt-geojson', github: 'URBANopt/urbanopt-geojson-gem', branch: 'develop'
# else
#   gem 'urbanopt-geojson', '0.1.0'
# end

gem 'openstudio-standards', '0.2.10' # doesn't work in 0.2.8?

# simplecov has an unneccesary dependency on native json gem, use fork that does not require this
gem 'simplecov', github: 'NREL/simplecov'

gem 'certified'

