
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


forecast_time = config_file$forecast_time
forecast_date = config_file$forecast_date
downscale = config_file$downscale
run_parallel = config_file$run_parallel
num_cores = config_file$num_cores


model_name <- "NOAAGEFS_6hr"
model_name_ds <-"NOAAGEFS_1hr" #Downscaled NOAA GEFS
model_name_ds_debias <-"NOAAGEFS_1hr-debias" #Downscaled NOAA GEFS
model_name_raw <- "NOAAGEFS_raw"

noaaGEFSpoint::process_gridded_noaa_download(lat_list = lat_list,
                                             lon_list = lon_list,
                                             site_list = site_list,
                                             downscale = downscale,
                                             debias = FALSE,
                                             overwrite = FALSE,
                                             model_name = model_name,
                                             model_name_ds = model_name_ds,
                                             model_name_ds_debias = model_name_ds_debias,
                                             model_name_raw = model_name_raw,
                                             num_cores = num_cores,
                                             output_directory = output_directory,
                                             reprocess = TRUE)
