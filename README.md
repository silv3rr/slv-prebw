# slv-prebw
### pzs-ng dZBot/ngbot plugin to show bw after pre

so what's so special about ANOTHER prebw script? well, this one works
seperate from pre script so you can prolly use it with every pre script
thats out there. also it's an pzs-ng plugin... or kinda ;) an other feature
is that it doesnt announce anything if there's no output bw made (can be
disabled tho). this is my first public script so if anything fucks up dont
blame me. also i dont like (obvious) questions about this, if it doesnt
work for you - too bad, it does for me! :p

you'll need:
- pzs-ng.
- pzs-ng's sitewho.
- site pre script that logs PRE to glftpd.log (tested with foopre).

* * *

1. put slv-prebw.sh in glftpd/bin dir.
2. put PreBW.tcl in eggdrop/scripts/pzs-ng/plugins/PreBW.tcl.

4. config slv-prebw.sh to your liking (paths, announce layout).<br>
   SLEEPS controls how many times it samples output bw, i.e:<br>
   "30 15 15 15 15" will output:<br>
   30s: 1@5.3mb/s 45s: 5@11.7mb/s 60s: 3@10.3mb/s 75s: 0@00kb/ 90s: 0@00kb/s

5. config PreBW.tcl<br>
   ngBot: keep this line: "`variable np [namespace qualifiers [namespace parent]]`"<br>
   -or-<br>
   dZSbot: comment line above and uncomment: `#variable np ""`<br>

   and if you put the .sh somewhere else change this path:<br>
   `set slvprebw "$glroot/bin/slv-prebw.sh"`

6. config dZSbot.conf / ngBot.conf<br>
   you need to add PREBW to msgtypes(SECTION)<br>
   -and-<br>
<pre>
   set redirect(PREBW)  $mainchan
   set disable(PREBW)   0
   set chanlist(PREBW)  $mainchan
   set variables(PREBW) "%pf %prebw"
</pre>

7. add to theme:<br>
   `announce.PREBW = "[%b{prebw }][%section] %prebw"`

8. add to eggdrop.conf:<br>
   `source scripts/pzs-ng/plugins/PreBW.tcl`

9. rehash your eggdrop, done.

