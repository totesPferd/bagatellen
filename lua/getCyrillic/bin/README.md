# `getCyrillic` - produce Russian letters with latin keyboards

`getCyrrilic` is a tiny lua unix filter program which transforms latin input to cyrillic output.

Use it as follows, e.g.:

	echo "Ty ponimaeqsh po-russkij?" | lua -l getCyrillic


## Installation

Use `luarocks` for installation:

	luarocks install https://raw.githubusercontent.com/totesPferd/bagatellen/master/lua/get_cyrillic-0.0.1-001.rockspec


## Transforming input Latin data to Russian output data

There are two working modes: Latin mode and Russian mode.  Russian mode is preset.  You can switch between these modes by adding `x` to the input stream.


### Transformation in Russian mode

Use Russian mode in order to produce Russian letters in the output.

&#x0410;&larr;A,
&#x0411;&larr;B,
&#x0412;&larr;V,
&#x0413;&larr;G,
&#x0414;&larr;D,
&#x0415;&larr;E,
&#x0401;&larr;Qo,
&#x0416;&larr;Qz,
&#x0417;&larr;Z,
&#x0418;&larr;I,
&#x0419;&larr;J,
&#x041a;&larr;K,
&#x041b;&larr;L,
&#x041c;&larr;M,
&#x041d;&larr;N,
&#x041e;&larr;O,
&#x041f;&larr;P,
&#x0420;&larr;R,
&#x0421;&larr;S,
&#x0422;&larr;T,
&#x0423;&larr;U,
&#x0424;&larr;F,
&#x0425;&larr;Qk,
&#x0426;&larr;C,
&#x0427;&larr;Qc,
&#x0428;&larr;Qs,
&#x0429;&larr;Qr,
&#x042a;&larr;Qh,
&#x042b;&larr;Y,
&#x042c;&larr;H,
&#x042d;&larr;Qe,
&#x042e;&larr;Qu,
&#x042f;&larr;Qa

and
&#x0430;&larr;a,
&#x0431;&larr;b,
&#x0432;&larr;v,
&#x0433;&larr;g,
&#x0434;&larr;d,
&#x0435;&larr;e,
&#x0451;&larr;qo,
&#x0436;&larr;qz,
&#x0437;&larr;z,
&#x0438;&larr;i,
&#x0439;&larr;j,
&#x043a;&larr;k,
&#x043b;&larr;l,
&#x043c;&larr;m,
&#x043d;&larr;n,
&#x043e;&larr;o,
&#x043f;&larr;p,
&#x0440;&larr;r,
&#x0441;&larr;s,
&#x0442;&larr;t,
&#x0443;&larr;u,
&#x0444;&larr;f,
&#x0445;&larr;qk,
&#x0446;&larr;c,
&#x0447;&larr;qc,
&#x0448;&larr;qs,
&#x0449;&larr;qr,
&#x044a;&larr;qh,
&#x044b;&larr;y,
&#x044c;&larr;h,
&#x044d;&larr;qe,
&#x044e;&larr;qu,
&#x044f;&larr;qa

All other input data will be passed through.

### Transformation in Latin mode

Use Latin mode in order to produce Latin letters in the output.

q&larr;qq,
x&larr;qx,
Q&larr;qQ,
X&larr;qX

All other input data will be passed through.
