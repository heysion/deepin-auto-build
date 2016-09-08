#!/usr/bin/python
# -*- coding: utf-8 -*-
'''
@date: 2016-09-02
@author: Heysion Yuan
@copyright: 2016, Heysion Yuan <heysions@gmail.com>
@license: GPLv3
'''
from da.tasks import Task as daTask
from da.source import Source as daSource
from dabdb.dbconn import dbinit
from sqlalchemy.sql import text
from datetime import datetime

import pdb

def get_list_daemoncli(session,channelname,hostname):
    """ get task  """
    #sqlt = {"channelname":"dptest","hostname":"dptest"}
    sqlcmd = """select taskinfo.id,state,
    to_char(create_time,'MM-DD-YYYY HH24:MI:SS'),taskinfo.build_name,
    srcinfo.name,srcinfo.version,srcinfo.dsc_file 
    from taskinfo join srcinfo on srcinfo.id = taskinfo.src_id  
    where taskinfo.channel_name='%s' and taskinfo.host_name='%s'"""%(channelname,
                                                                     hostname)

    dbfetch = session.execute(sqlcmd)
    dataset = dbfetch.fetchall()
    return dataset


def update_daemoncli(session,taskid,channelname,hostname,state,starttime,completiontime):
    task_obj = session.query(daTask).filter(daTask.id==taskid).first()
    if task_obj.state in (0,None) and state == 100:
        task_obj.starttime = datetime.now()
    if state in (400,500):
        task_obj.completiontime = datetime.now()
    task_obj.state = state
    pdb.set_trace()
    session.flush()
    session.commit()
    print(task_obj.__dict__)
    # 0 init 100 submit 200 start 300 build 400 failed 500 success 
    pass

if __name__ == "__main__":
    db,session = dbinit("postgres")
    ret_data = update_daemoncli(session,1,
                                channelname=None,hostname="dptest",
                                state=100,starttime=None,
                                completiontime=None)
    print(ret_data)
    pass
    
