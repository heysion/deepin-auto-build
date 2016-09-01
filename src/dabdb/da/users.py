#!/usr/bin/python
# -*- coding: utf-8 -*-
'''
@date: 2016-08-14
@author: Heysion Yuan
@copyright: 2016, Heysion Yuan <heysions@gmail.com>
@license: GPLv3
'''

from sqlalchemy import Column, ForeignKey, Integer, String
from sqlalchemy.orm import relationship
from sqlalchemy import UniqueConstraint

from __init__ import Base,da_session,da_create_engine
from __init__ import da_init_test as dainit

class User(Base):
    __tablename__ = 'userinfo'
    id = Column(Integer, primary_key=True)
    name = Column(String(128), nullable=False ,unique = True)
    password = Column(String(256),nullable=False)
    ssalt = Column(String(32))
    status = Column(Integer)
    usertype = Column(Integer)
    #host = relationship("Host",backref="userinfo",uselist=False)
    __table_args__= (UniqueConstraint("name",name="username_o_1"),)


def run_test():
    session = dainit(True)
    new_obj = User(name="test",password="qwe123")
    session.add(new_obj)
    session.commit()

if __name__ == "__main__":
    run_test()
    pass    
