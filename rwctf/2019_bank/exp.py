from zio import *
import os
import hashlib
from schnorr import *
import base64

target=("tcp.realworldctf.com",20014)
#target=("127.0.0.1",20014)
io=zio(target, print_read = COLORED(REPR, 'red'), print_write = COLORED(REPR, 'blue'), timeout = 100000)

def pass_proof(io):
    io.read_until("starting with ")
    start=io.readline().strip()
    while True:
        end=os.urandom(5)
        if hashlib.sha1(start+end).hexdigest()[-4:]=="0000":
            io.write(start+end)
            return


pass_proof(io)

io.read_until("Please tell us your public key:")
mysk, mypk = generate_keys()
print mysk
print mypk
send_pubkey=base64.b64encode(str(mypk[0])+","+str(mypk[1]))
io.writeline(send_pubkey)

io.read_until("first priority!")
io.writeline("3".encode("base64").strip())
io.read_until("himself as one of us: (")
getpubkey=io.read_until(")").split(",")
pubkey=(int(getpubkey[0].replace("L","")),int(getpubkey[1].split("L")[0]))
print pubkey

io.read_until("Please tell us your public key:")
io.writeline(send_pubkey)
io.read_until("our first priority!")
io.writeline("1".encode("base64").strip())
io.read_until("Please send us your signature")
io.writeline(base64.b64encode(schnorr_sign("DEPOSIT", mysk)))

io.read_until("Please tell us your public key:")
roguepk=point_sub(mypk,pubkey)
send_roguepubkey=base64.b64encode(str(roguepk[0])+","+str(roguepk[1]))
io.writeline(send_roguepubkey)
io.read_until("our first priority!")
io.writeline("2".encode("base64").strip())
io.read_until("Please send us your signature")
io.writeline(base64.b64encode(schnorr_sign("WITHDRAW", mysk)))

#Here is your coin: rwctf{P1Ain_SChNorr_n33Ds_m0re_5ecur1ty!}
io.interact()