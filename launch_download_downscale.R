
#Use these for using code on local machine
#output_directory <- "/Users/quinn/Downloads/GEFS_test"
#configuration_yaml <- "/Users/quinn/Dropbox/Research/EFI_RCN/NOAA_GEFS_download/NOAA_GEFS_container/example/noaa_download_scale_config.yml"

#source files and set paths on container
#these directories won't change on container
message(paste("Running NOAA scripts starting at:", as.character(Sys.time())))

output_directory <- normalizePath(file.path(Sys.getenv("MINIO_HOME"), "drivers/noaa"))
configuration_yaml <- "noaa_download_scale_config.yml"

#Read configuration file
config_file <- yaml::read_yaml(configuration_yaml)

#Read list of latitude and longitudes
neon_sites <- readr::read_csv(config_file$site_file)
site_list <- neon_sites$site_id
lat_list <- neon_sites$latitude
lon_list <- neon_sites$longitude

message(paste0("Site file: ", config_file$site_file))

noaaGEFSpoint::noaa_gefs_download_downscale(site_list = site_list,
                                            lat_list = lat_list,
                                            lon_list= lon_list,
                                            output_directory = output_directory,
                                            forecast_time = config_file$forecast_time,
                                            forecast_date = config_file$forecast_date,
                                            downscale = config_file$downscale,
                                            run_parallel = config_file$run_parallel,
                                            num_cores = config_file$num_cores,
                                            method = "grid",
                                            overwrite = FALSE)

