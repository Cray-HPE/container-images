from prometheus_client.core import GaugeMetricFamily

import logging
import math
import re
import datetime

class HealthCollector(object):

    def __enter__(self):
        return self

    def __init__(self, redfish_metrics_collector):

        self.col = redfish_metrics_collector

        self.health_metrics = GaugeMetricFamily(
            "redfish_health",
            "Redfish Server Monitoring Health Data",
            labels=self.col.labels,
        )
        self.mem_metrics_correctable = GaugeMetricFamily(
            "redfish_memory_correctable",
            "Redfish Server Monitoring Memory Data for correctable errors",
            labels=self.col.labels,
        )
        self.mem_metrics_unorrectable = GaugeMetricFamily(
            "redfish_memory_uncorrectable",
            "Redfish Server Monitoring Memory Data for uncorrectable errors",
            labels=self.col.labels,
        )
    
    def parse_nvme_info(self, providing_drives):
        attributes = {
             "Critical warning": "",
             "Device model": "",
             "Exit status": "",
             "Media errors": "",
             "Percentage used": "",
             "Power on hours": "",
             "Power_Cycle_Count": "",
             "Serial number": "",
             "Smartctl error": "",
             "Temperature": ""
             }
        oem_data = providing_drives.get("Oem", {})
        smart_data = oem_data.get("SmartData", {})
        disk_name = None
        for key in smart_data.keys():
           if "[" in key and "]" in key:
               disk_name = key.split("[")[1].split("]")[0]
               break
        logging.info(disk_name)
        for key, value in smart_data.items():
            for attr_key in attributes:
                if attr_key in key:
                     attributes[attr_key] = value.lower()

        current_labels = {"disk": f"/dev/{disk_name}", "type": providing_drives.get("MediaType", "").lower()}
        current_labels.update(self.col.labels)

        # smartmon_device_smart_healthy
        smart_health = math.nan
        smart_status = dict( (k.lower(), v) for k, v in providing_drives["Status"].items() )
        if "state" in smart_status and smart_status["state"] != "absent":
            smart_health = ( math.nan if smart_status["state"]  is None else self.col.status[smart_status["state"].lower()] )
            if smart_health is math.nan:
                logging.warning(f"Target {self.col.target}: Host {self.col.host}, Model {device_model}: No health data found.")
        self.health_metrics.add_sample("smartmon_device_smart_healthy", value=smart_health, labels=current_labels)

        # smartmon_device_info
        info_labels = {"disk": f"/dev/{disk_name}", "type": providing_drives.get("MediaType", "").lower(),"serial_number": attributes.get("Serial number", ""),"model_family": attributes.get("Device model", "").lower() }
        self.health_metrics.add_sample("smartmon_device_smart_info", value=smart_health, labels=info_labels)

        # smartmon_temperature_celsius_raw_value
        temperature_value = ''.join(filter(str.isdigit, attributes.get("Temperature", "")))
        temperature_float = float(temperature_value)
        self.health_metrics.add_sample("smartmon_temperature_celsius_raw_value", value=temperature_float, labels=current_labels)
        
        # smartmon_power_cycles_count_raw_value
        power_cycle = int(attributes.get("Power_Cycle_Count", 0))
        self.health_metrics.add_sample("smartmon_power_cycles_count_raw_value", value=power_cycle, labels=current_labels)

        # smartmon_power_on_hours_raw_value
        power_on_hours = int(attributes.get("Power on hours", 0))
        self.health_metrics.add_sample("smartmon_power_on_hours_raw_value", value=power_on_hours, labels=current_labels)
        
        # smartmon_percentage_used_raw_value
        percentage_used = attributes.get("Percentage used", "0%")
        percentage_used = int(percentage_used.strip('%'))
        self.health_metrics.add_sample("smartmon_percentage_used_raw_value", value=percentage_used, labels=current_labels)

        # smartmon_media_and_data_integrity_errors_count_raw_value
        media_errors = int(attributes.get("Media errors", 0))
        self.health_metrics.add_sample("smartmon_media_and_data_integrity_errors_count_raw_value", value=media_errors, labels=current_labels)

        # smartmon_smartctl_run
        run_time = int(datetime.datetime.now(datetime.timezone.utc).timestamp())
        self.health_metrics.add_sample("smartmon_smartctl_run", value=run_time, labels=current_labels)


    def parse_scsi_info(self, providing_drives):
        attributes = {
             "Device model": "",
             "Exit status": "",
             "Percentage used": "",
             "Power on hours": "",
             "Power_Cycle_Count": "",
             "Serial number": "",
             "Smartctl error": "",
             "Temperature": ""
             }
        oem_data = providing_drives.get("Oem", {})
        smart_data = oem_data.get("SmartData", {})
        disk_name = None
        for key in smart_data.keys():
           if "[" in key and "]" in key:
               disk_name = key.split("[")[1].split("]")[0]
               break
        logging.info(disk_name)
        for key, value in smart_data.items():
            for attr_key in attributes:
                if attr_key in key:
                     attributes[attr_key] = value.lower()
        current_labels = {"disk": f"/dev/{disk_name}", "type": providing_drives.get("MediaType", "").lower()}
        current_labels.update(self.col.labels)

        # smartmon_device_smart_healthy
        smart_health = math.nan
        smart_status = dict( (k.lower(), v) for k, v in providing_drives["Status"].items() )
        if "state" in smart_status and smart_status["state"] != "absent":
            smart_health = ( math.nan if smart_status["state"]  is None else self.col.status[smart_status["state"].lower()] )
            if smart_health is math.nan:
                logging.warning(f"Target {self.col.target}: Host {self.col.host}, Model {device_model}: No health data found.")
        self.health_metrics.add_sample("smartmon_device_smart_healthy", value=smart_health, labels=current_labels)

        # smartmon_device_info
        info_labels = {"disk": f"/dev/{disk_name}", "type": providing_drives.get("MediaType", "").lower(),"serial_number": attributes.get("Serial number", ""),"model_family": attributes.get("Device model", "").lower() }
        self.health_metrics.add_sample("smartmon_device_smart_info", value=smart_health, labels=info_labels)

        # smartmon_temperature_celsius_raw_value
        temperature_value = ''.join(filter(str.isdigit, attributes.get("Temperature", "")))
        temperature_float = float(temperature_value)
        self.health_metrics.add_sample("smartmon_temperature_celsius_raw_value", value=temperature_float, labels=current_labels)

        # smartmon_power_cycles_count_raw_value
        power_cycle = int(attributes.get("Power_Cycle_Count", 0))
        self.health_metrics.add_sample("smartmon_power_cycles_count_raw_value", value=power_cycle, labels=current_labels)

        # smartmon_power_on_hours_raw_value
        power_on_hours = int(attributes.get("Power on hours", 0))
        self.health_metrics.add_sample("smartmon_power_on_hours_raw_value", value=power_on_hours, labels=current_labels)

        # smartmon_percentage_used_raw_value
        percentage_used = attributes.get("Percentage used", "0%")
        percentage_used = int(percentage_used.strip('%'))
        self.health_metrics.add_sample("smartmon_percentage_used_raw_value", value=percentage_used, labels=current_labels)


    def get_smart_data(self):        

        logging.debug(f"Target {self.col.target}: Get the SMART data.")
        storage_services_collection = self.col.connect_server(self.col.urls["StorageServices"])
        if not storage_services_collection:
           return

        for storage_service_member in storage_services_collection["Members"]:
            for key, storage_url in storage_service_member.items():
               if key.startswith("enclosure_id"):
                  storage_service = self.col.connect_server(storage_url)

                  storage_pool_collection = self.col.connect_server(storage_service["StoragePools"]['@odata.id'])
                  if not storage_pool_collection:
                     return

                  for storage_pool_member in storage_pool_collection["Members"]:

                      for pool, pool_url in storage_pool_member.items():
                          if pool.startswith("enclosure_id"):
                             storage_pool = self.col.connect_server(pool_url)
                             self.col.urls["CapacitySources"]=f"{storage_pool['@odata.id']}/CapacitySources" 
                             
                             capacity_source_collection = self.col.connect_server(self.col.urls["CapacitySources"])
                             if not capacity_source_collection:
                                return
                             for capacity_source_member in capacity_source_collection["Members"]:
                                 for capacity, capacity_url in capacity_source_member.items():
                                     if capacity.startswith("@odata.id"):
                                        capacity_source = self.col.connect_server(capacity_url)
                                              
                                        self.col.urls["ProvidingDrives"]=f"{capacity_source['@odata.id']}/ProvidingDrives"
                                        providing_drives_collection = self.col.connect_server(self.col.urls["ProvidingDrives"])
                                        if not providing_drives_collection:
                                           return
                                        for providing_drives_member in providing_drives_collection["Members"]:
                                            for drives, drives_url in providing_drives_member.items():
                                                if drives.startswith("Bay") and not drives_url.endswith("Not Installed"):
                                                   providing_drives = self.col.connect_server(drives_url)
                                        
                                                   media_type = providing_drives["MediaType"].lower()
                                                   if media_type == "nvme":
                                                       self.parse_nvme_info(providing_drives)

                                                   if media_type == "sas":
                                                       self.parse_scsi_info(providing_drives)

    def collect(self):

        logging.info(f"Target {self.col.target}: Collecting data ...")
        current_labels = {"device_type": "system", "device_name": "summary"}
        current_labels.update(self.col.labels)
        self.health_metrics.add_sample(
            "redfish_health", value=self.col.server_health, labels=current_labels
        )
   
        # Export the SMART data
        if self.col.urls["StorageServices"]:
            self.get_smart_data()
        else:
            logging.warning(f"Target {self.col.target}: No SMART data provided! Cannot get SMART data!")
           
    def __exit__(self, exc_type, exc_val, exc_tb):
        if exc_tb is not None:
            logging.exception(f"Target {self.target}: An exception occured in {exc_tb.tb_frame.f_code.co_filename}:{exc_tb.tb_lineno}")
