from sys import argv
import os

SERVICE_DATA = {
    # "TradeManager": {
    #     "executable": "BT.TradeManager.Service.ConsoleHost.exe",
    #     "isService": True,
    #     "instanceName": "cgreen",
    #     "prometheusComponent": "TradeManager"
    # },
    # "TradeManagerClient": {
    #     "executable": "BT.TradeManager.Presentation.Win.UI.exe",
    #     "isService": False
    # },
    # "Saber": {
    #     "executable": "BT.Saber.Presentation.Win.exe",
    #     "isService": False
    # },
    "RiskClient": {
        "executable": "BT.RiskFramework.Presentation.Win.UI.WPF.MasterRiskStandalone.exe",
        "isService": False
    },
    "RiskService": {
        "executable": "BT.RiskFramework.Service.Console.Host.exe",
        "isService": True,
        "instanceName": "cgreen",
        "prometheusComponent": "RiskFramework"
    },
    "PnlService": {
        "executable": "BT.PnlFramework.Service.Console.Host.exe",
        "isService": True,
        "instanceName": "cgreen",
        "prometheusComponent": "PnlFramework"
    },
    "OpsService": {
        "executable": "BT.OptionPricing.Service.Win.UI.exe",
        "isService": True,
        "instanceName": "cgreen",
        "prometheusComponent": "OptionPricing"
    },
    "OpsClient": {
        "executable": "BT.OptionPricing.Presentation.Win.ToolbarUI.exe",
        "isService": False
    },
    # "TradeRouting": {
    #     "executable": "BT.TradeRouting.Service.ConsoleHost.exe",
    #     "isService": True,
    #     "instanceName": "cgreen",
    #     "serviceCompositeId": "78690"
    # },
    # "LaserClient": {
    #     "executable": "BT.HighFrequency.Presentation.Win.UI.exe",
    #     "isService": False
    # },
    "ModelFixer": {
        "executable": "ModelFixer.exe",
        "isService": False
    },
    "cgreen_theo": {
        "executable": "BT.HighFrequency.Service",
        "isService": True,
        "instanceName": "cgreen_theo",
        "prometheusComponent": "Laser"
    },
    "cgreen_hf": {
        "executable": "BT.HighFrequency.Service",
        "isService": True,
        "instanceName": "cgreen_hf",
        "prometheusComponent": "Laser"
    },
    "LOPS": {
        "executable": "LaserOptionPricing",
        "isService": True,
        "instanceName": "cgreen",
        "prometheusComponent": "LaserOptionPricing"
    }
    # "JobScheduler": {
    #     "executable": "ModelFixer.exe",
    #     "isService": False,
    #     "instanceName": "cgreen",
    #     "prometheusComponent": "JobScheduler"
    # },
    # "JobScheduler32": {
    #     "executable": "ModelFixer.exe",
    #     "isService": False,
    #     "instanceName": "cgreen",
    #     "prometheusComponent": "JobScheduler32"
    # },
}


if __name__ == '__main__':
    teamColor = argv[1] if len(argv) == 2 else None

    for v in SERVICE_DATA.itervalues():
        try:
            comp = v['prometheusComponent']
            for db in ['NewModel', 'TestingBelvedereTechnology']:
                db_name = '{}_{}'.format(db, teamColor) if teamColor else db
                cmd = '/usr/local/bin/hydra instance modify db-pointings {} {} {} -d {}'.format(comp, v['instanceName'], db, db_name)
                os.system(cmd)
        except KeyError:
            print v
            continue
