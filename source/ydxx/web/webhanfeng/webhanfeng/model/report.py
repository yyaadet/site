from webhanfeng.lib.utils import *
import meta

@catch_exception
def new_report(sender_id,name,description):
    report = Report()
    report.sender_id = sender_id
    report.name = name
    report.description = description
    report.date = int(time.time())
    meta.Session.add(report)
    meta.Session.commit()
    return report

@catch_exception
def get_report_by_id(id):
    r = meta.Session.query(Report).filter(Report.id == id).first()
    return r

@catch_exception
def get_all_report(offset=None,limit=None):
    if limit is None or offset is None:
        r = meta.Session.query(Report).order_by(Report.id.asc()).all()
    else:
        r = meta.Session.query(Report).order_by(Report.id.asc()).limit(limit).offset(offset).all()
    return r

def get_report_count():
    m = meta.Session.query(Report).count()
    return m

@catch_exception
def delete_report_by_id(id):
    report = meta.Session.query(Report).filter(Report.id == id).first()
    meta.Session.delete(report)
    meta.Session.commit()

@catch_exception
def delete_report_all():
    report = meta.Session.query(Report).all()
    for i in report:
        meta.Session.delete(i)
    meta.Session.commit()

class Report(object): pass