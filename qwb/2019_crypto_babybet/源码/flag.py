import hashlib
def getflag(teamtoken):
    return "flag{"+hashlib.sha256("fj384h19vxz72345"+hashlib.md5(teamtoken).hexdigest()).hexdigest()+"}"