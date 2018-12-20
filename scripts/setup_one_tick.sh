#!/usr/bin/env bash
# Create OneTick roles
# Necessary to use any Python project with PyOneTick
sudo echo
sudo salt-call btutils.addrole onetick_client
sudo salt-call saltutil.refresh_pillar
sudo salt-call state.apply states.onetick.client

