from java.util import Properties
from java.io import FileInputStream
from java.io import File
from java.io import FileOutputStream
from java import io
from java.lang import Exception
from java.lang import Throwable
import os.path
import sys

###################****##############****########################
# ScriptName    : CreateJMSObjects-v1.4.py
# Properties    : ConfigJMSObjects.properties
# Author        : Pavan Devarakonda / Ariel Cassan
###################****##############****########################

propInputStream=FileInputStream(sys.argv[1])
configProps=Properties()
configProps.load(propInputStream)

def getJMSSubdeploymentPath(jms_module_name):
        jms_subdeployment_path = "/JMSSystemResources/"+jms_module_name+"/SubDeployments/"+subdeployment_name
        return jms_subdeployment_path

def deleteJMSModule(jms_module_name):
        deleteIgnoringExceptions(jms_module_name)

def createJMSModule(jms_module_name,server_target_name):
        jms_subdeployment_path= getJMSSubdeploymentPath(jms_module_name)
        cd('/JMSServers')
        jmssrvlist=ls(returnMap='true')
        cd('/')
        module = create(jms_module_name, "JMSSystemResource")
        server = getMBean("Servers/"+server_target_name)
        module.addTarget(server)
        cd('/SystemResources/'+jms_module_name)

        module.createSubDeployment(subdeployment_name)
        cd(jms_subdeployment_path)
        list=[]
        for j in jmssrvlist:
                s='com.bea:Name='+j+',Type=JMSServer'
                list.append(ObjectName(str(s)))
        set('Targets',jarray.array(list, ObjectName))

def getJMSModulePath(jms_module_name):
        jms_module_path = "/JMSSystemResources/"+jms_module_name+"/JMSResource/"+jms_module_name
        return jms_module_path

def getJMSQueuePath(jms_module_name,qname):
        jms_queue_path = getJMSModulePath(jms_module_name)+"/Queues/"+qname
        return jms_queue_path

def createJMSQueue(jms_module_name,jndi,jms_q_name,target,q_rl,q_ep,q_ed):
        jms_module_path= getJMSModulePath(jms_module_name)
        jms_subdeployment_path= getJMSSubdeploymentPath(jms_module_name)
        cd(jms_module_path)
        cmo.createQueue(jms_q_name)
        cd(getJMSQueuePath(jms_module_name,jms_q_name))
        cmo.setJNDIName(jndi)
    #    cmo.setDefaultTargetingEnabled(bool("true"))
        cmo.setSubDeploymentName(subdeployment_name)
        cd(jms_subdeployment_path)
        cmo.addTarget(getMBean("/JMSServers/"+target))
        cd(getJMSQueuePath(jms_module_name,jms_q_name)+"/DeliveryFailureParams/"+jms_q_name)
        cmo.setRedeliveryLimit(int(q_rl))
        cmo.setExpirationPolicy(q_ep)
        erQueue = getMBean(getJMSQueuePath(jms_module_name,q_ed))
        cmo.setErrorDestination(erQueue)


def createJMSUDQ(jms_module_name,jndi,jms_udq_name,target):
        jms_module_path = getJMSModulePath(jms_module_name)
        jms_subdeployment_path= getJMSSubdeploymentPath(jms_module_name)
        cd(jms_module_path)
        cmo.createUniformDistributedQueue(jms_udq_name)
        cd(jms_module_path+'/UniformDistributedQueues/'+jms_udq_name)
        cmo.setJNDIName(jndi)
    #    cmo.setDefaultTargetingEnabled(bool("true"))
        cmo.setSubDeploymentName(subdeployment_name)
        print('JMS Module path: '+jms_module_path)
        cd(jms_module_path+'/UniformDistributedQueues/'+jms_udq_name)
        set('ForwardDelay', 10)
        cd(jms_subdeployment_path)
        cmo.addTarget(getMBean("/JMSServers/"+target))
        path_tmp = getJMSQueuePath(jms_module_name,jms_udq_name)
        print('temporary path  : [%s]' % path_tmp)

        cd(path_tmp+"/DeliveryFailureParams/"+jms_udq_name)
        cmo.setRedeliveryLimit(3)
        cmo.setExpirationPolicy('Redirect')
        erQueue = getMBean(getJMSQueuePath(jms_module_name,'object_error_queue'))
        cmo.setErrorDestination(erQueue)


def createJMSConnectionFactory(jms_module_name,cfjndi,jms_cf_name,target):
        jms_module_path = getJMSModulePath(jms_module_name)
        jms_subdeployment_path= getJMSSubdeploymentPath(jms_module_name)
        cd(jms_module_path)
        cf = create(jms_cf_name,'ConnectionFactory')
        jms_cf_path = jms_module_path+'/ConnectionFactories/'+jms_cf_name
        cd(jms_cf_path)
        cf.setJNDIName(cfjndi)
        cf.setSubDeploymentName(subdeployment_name)
        cd (jms_cf_path+'/SecurityParams/'+jms_cf_name)
        #cf.setAttachJMXUserId(bool("false"))
        cd(jms_cf_path+'/ClientParams/'+jms_cf_name)
        cmo.setClientIdPolicy('Restricted')
        cmo.setSubscriptionSharingPolicy('Exclusive')
        cmo.setMessagesMaximum(10)
        cd(jms_cf_path+'/TransactionParams/'+jms_cf_name)
        set('TransactionTimeout', "3600")
        set('XAConnectionFactoryEnabled', "true")
        # cd(jms_cf_path)
        # cmo.setDefaultTargetingEnabled(bool("true"))
        cd(jms_subdeployment_path)
        cmo.addTarget(getMBean("/JMSServers/"+target))

def createFlstr(fstr_name_p,dir_name_p,target_name_p):
        cd('/')
        fst = create(fstr_name_p, "FileStore")
        cd('/FileStores/'+fstr_name_p)
        cmo.setDirectory(dir_name_p)
        fst.addTarget(getMBean("/Servers/"+target_name_p))

def createJDstr(jstr_name_p,ds_name_p,target_name_p,prefix_p):
        cd('/')
        jst = create(jstr_name_p, "JDBCStore")
        cd('/JDBCStores/'+jstr_name_p)
        cmo.setDataSource(getMBean('/SystemResources/'+ds_name_p))
        cmo.setPrefixName(prefix_p)
        jst.addTarget(getMBean("/Servers/"+target_name_p))

def createJMSsrvr(jms_srv_name_p,target_name_p,persis_store_p,page_dir_p, thrs_high_p, thrs_low_p, msg_size_p):
        cd('/')
        srvr = create(jms_srv_name_p, "JMSServer")
        cd('/Deployments/'+jms_srv_name_p)
        srvr.setPersistentStore(getMBean('/FileStores/'+persis_store_p))
#       srvr.setPersistentStore(getMBean('/JDBCStores/'+persis_store))
        srvr.setPagingDirectory(page_dir_p)
        srvr.addTarget(getMBean("/Servers/"+target_name_p))
        srvr.setBytesThresholdLow(long(thrs_low_p))
        srvr.setBytesThresholdHigh(long(thrs_high_p))
        srvr.setMaximumMessageSize(long(msg_size_p))

adminUser=configProps.get("adminUser")
adminPassword=configProps.get("adminPassword")
adminURL=configProps.get("adminURLProtocol")+'://'+configProps.get("adminURL")

connect(adminUser,adminPassword,adminURL)

edit()
startEdit()

#=============# JMS SERVER and PERSISITENT STORE CONFIGURATION #=============#
jms_srv_name=configProps.get("jms_srvr_name")
trg=configProps.get("jms_srvr_target")
persis_store=configProps.get("jms_srvr_persis_store_name")
page_dir=configProps.get("jms_srvr_pag_dir")
thrs_high=configProps.get("jms_srvr_by_threshold_high")
thrs_low=configProps.get("jms_srvr_by_threshold_low")
msg_size=configProps.get("jms_srvr_max_msg_size")
total_q=configProps.get("total_q")
total_udq=configProps.get("total_udq")
total_conf=configProps.get("total_conf")
tot_djmsm=configProps.get("total_default_jms_module")
subdeployment_name=configProps.get("subdeployment_name")
jms_srv_target=configProps.get("jms_srv_objects_target")


createFlstr(persis_store,page_dir,trg)
java.lang.Thread.sleep(5000)
print(jms_srv_name+','+trg+','+persis_store+','+page_dir+','+thrs_high+','+thrs_low+','+msg_size)
createJMSsrvr(jms_srv_name,trg,persis_store,page_dir,thrs_high,thrs_low,msg_size)

 # ====# JMS CONFIGURATION## ##########################################


a=1
while(a <= int(tot_djmsm)):
        var1=int(a)
        jms_mod_name=configProps.get("jms_mod_name"+ str(var1))
        server_target=configProps.get("jms_mod_target"+ str(var1))
        createJMSModule(jms_mod_name,server_target)

        i=1
        while(i <= int(total_q)):
                q_name=configProps.get("q_name"+ str(i))
                q_jndi=configProps.get("q_jndi"+ str(i))
                q_rl=configProps.get("q_rl"+ str(i))
                q_ep=configProps.get("q_ep"+ str(i))
                q_ed=configProps.get("q_ed"+ str(i))
                createJMSQueue(jms_mod_name,q_jndi,q_name,jms_srv_target,q_rl,q_ep,q_ed)
                i = i + 1
        j=1
        while(j <= int(total_udq)):
                udq_name=configProps.get("udq_name"+ str(j))
                udq_jndi=configProps.get("udq_jndi"+ str(j))
#                createJMSUDQ(jms_mod_name,udq_jndi,udq_name,jms_srv_target)
                j = j + 1
        k = 1
        while(k <= int(total_conf)):
                conf_name=configProps.get("conf_name"+ str(k))
                conf_jndi=configProps.get("conf_jndi"+ str(k))
                createJMSConnectionFactory(jms_mod_name,conf_jndi,conf_name,jms_srv_target)
                k = k + 1
        a = a+1

save()
activate(block="true")
disconnect()

exit()
