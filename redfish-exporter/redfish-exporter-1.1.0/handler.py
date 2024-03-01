import falcon
import logging
import socket
import re
import os
import json
import sys
import traceback

from prometheus_client.exposition import CONTENT_TYPE_LATEST
from prometheus_client.exposition import generate_latest

from collector import RedfishMetricsCollector

class welcomePage:
    def on_get(self, req, resp):
        resp.status = falcon.HTTP_200
        resp.content_type = 'text/html'
        resp.body = """
        <h1>Redfish Exporter</h1>
        <h2>Prometheus Exporter for redfish API based servers monitoring</h2>
        <ul>
            <li>Use <a href="/redfish">/redfish</a> to retrieve health metrics.</li>
            <li>Use <a href="/firmware">/firmware</a> to retrieve firmware version metrics.</li>
        </ul>
        """


class metricsHandler:
    def __init__(self, config, metrics_type):
        self._config = config
        self.metrics_type = metrics_type

    def on_get(self, req, resp):
        self.target = req.get_param("target")
        if not self.target:
            logging.error("No target parameter provided!")
            raise falcon.HTTPMissingParam("target")

        logging.debug(f"Received Target: {self.target}")

        #self._job = req.get_param("job")
        #if not self._job:
        #    logging.error(f"Target {self.target}: No job provided!")
        #    raise falcon.HTTPMissingParam("job")

        #logging.debug(f"Received Job: {self._job}")

        ip_re = re.compile(
            r"^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"
        )

        resp.set_header("Content-Type", CONTENT_TYPE_LATEST)

        if ip_re.match(self.target):
            logging.debug(f"Target {self.target}: Target is an IP Address.")
            try:
                host = socket.gethostbyaddr(self.target)[0]
                if host:
                    self.host = host
            except socket.herror as err:
                msg = f"Target {self.target}: Reverse DNS lookup failed: {err}"
                logging.error(msg)
                raise falcon.HTTPInvalidParam(msg, "target")
        else:
            logging.debug(f"Target {self.target}: Target is a hostname.")
            self.host = self.target
            try:
                target = socket.gethostbyname(self.host)
                if target:
                    self.target = target
            except socket.gaierror as err:
                msg = f"Target {self.target}: DNS lookup failed: {err}"
                logging.error(msg)
                raise falcon.HTTPInvalidParam(msg, "target")

        #usr_env_var = self._job.replace("-", "_").upper() + "_USERNAME"
        #pwd_env_var = self._job.replace("-", "_").upper() + "_PASSWORD"
        usr = self._config.get("username")
        pwd = self._config.get("password")

        logging.debug(f"Target {self.target}: Using user {usr}")

        with RedfishMetricsCollector(
            self._config,
            target = self.target,
            host = self.host,
            usr = usr,
            pwd = pwd, 
            metrics_type = self.metrics_type
        ) as registry:

            # open a session with the remote board
            registry.get_session()

            try:
                # collect the actual metrics
                resp.body = generate_latest(registry)
                resp.status = falcon.HTTP_200

            except Exception as err:
                message = f"Exception: {traceback.format_exc()}"
                logging.error(f"Target {self.target}: {message}")
                raise falcon.HTTPBadRequest("Bad Request", message)
