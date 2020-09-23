
// define a few datasets
(
~pitchDS = FluidDataSet(s,\pitch11);
~loudDS = FluidDataSet(s,\loud11);
~mfccDS = FluidDataSet(s,\mfcc11);
~durDS = FluidDataSet(s,\dur11);


//define as many buffers as we have parallel voices/threads in the extractor processing (default is 4)
~pitchbuf = 4.collect{Buffer.new};
~statsPitchbuf = 4.collect{Buffer.new};
~weightPitchbuf = 4.collect{Buffer.new};
~flatPitchbuf = 4.collect{Buffer.new};
~loudbuf = 4.collect{Buffer.new};
~statsLoudbuf = 4.collect{Buffer.new};
~flatLoudbuf = 4.collect{Buffer.new};
~weightMFCCbuf = 4.collect{Buffer.new};
~mfccbuf = 4.collect{Buffer.new};
~statsMFCCbuf = 4.collect{Buffer.new};
~flatMFCCbuf = 4.collect{Buffer.new};

// here we instantiate a loader as per example 0
// ~loader = FluidLoadFolder(File.realpath(FluidBufPitch.class.filenameSymbol).dirname.withTrailingSlash ++ "../AudioFiles/");
// ~loader = FluidLoadFolder("/Volumes/machins/projets/newsfeed/sons/smallnum/");
~loader = FluidLoadFolder("/Volumes/machins/projets/newsfeed/sons/segments/");

// here we instantiate a further slicing step as per example 0
~slicer = FluidSliceCorpus({ |src,start,num,dest|
	FluidBufOnsetSlice.kr(src,start,num,metric: 9, minSliceLength: 17, indices:dest, threshold:0.2,blocking: 1)
});


// here we make the full processor building our 3 source datasets
~extractor = FluidProcessSlices({|src,start,num,data|
	var label, voice, pitch, pitchweights, pitchstats, pitchflat, loud, statsLoud, flattenLoud, mfcc, mfccweights, mfccstats, mfccflat, writePitch, writeLoud;
	label = data.key;
    voice = data.value[\voice];
	// the pitch computation is independant so it starts right away
	pitch = FluidBufPitch.kr(src, startFrame:start, numFrames:num, numChans:1, features:~pitchbuf[voice], unit: 1, trig:1, blocking: 1);
	pitchweights = FluidBufThresh.kr(~pitchbuf[voice], numChans: 1, startChan: 1, destination: ~weightPitchbuf[voice], threshold: 0.1, trig:Done.kr(pitch), blocking: 1);//pull down low conf
	// pitchweights = FluidBufScale.kr(~pitchbuf[voice], numChans: 1, startChan: 1, destination: ~weightPitchbuf[voice],inputLow: -1, trig:Done.kr(pitch), blocking: 1);
	pitchstats = FluidBufStats.kr(~pitchbuf[voice], stats:~statsPitchbuf[voice], numDerivs: 1, weights: ~weightPitchbuf[voice], outliersCutoff: 1.5, trig:Done.kr(pitchweights), blocking: 1);
	pitchflat = FluidBufFlatten.kr(~statsPitchbuf[voice],~flatPitchbuf[voice],trig:Done.kr(pitchstats),blocking: 1);
	writePitch = FluidDataSetWr.kr(~pitchDS,label, -1, ~flatPitchbuf[voice], Done.kr(pitchflat),blocking: 1);
	// the mfcc need loudness to weigh, so let's start with that
	loud = FluidBufLoudness.kr(src,startFrame:start, numFrames:num, numChans:1, features:~loudbuf[voice], trig:Done.kr(writePitch), blocking: 1);//here trig was 1
	//we can now flatten and write Loudness in its own trigger tree
	statsLoud = FluidBufStats.kr(~loudbuf[voice], stats:~statsLoudbuf[voice], numDerivs: 1, trig:Done.kr(loud), blocking: 1);
	flattenLoud = FluidBufFlatten.kr(~statsLoudbuf[voice],~flatLoudbuf[voice],trig:Done.kr(statsLoud),blocking: 1);
	writeLoud = FluidDataSetWr.kr(~loudDS,label, -1, ~flatLoudbuf[voice], Done.kr(flattenLoud),blocking: 1);
	//we can resume from the loud computation trigger
	mfcc = FluidBufMFCC.kr(src,startFrame:start,numFrames:num,numChans:1,features:~mfccbuf[voice],trig:Done.kr(writeLoud),blocking: 1);//here trig was loud
	mfccweights = FluidBufScale.kr(~loudbuf[voice],numChans: 1,destination: ~weightMFCCbuf[voice],inputLow: -70,inputHigh: 0, trig: Done.kr(mfcc), blocking: 1);
	mfccstats = FluidBufStats.kr(~mfccbuf[voice], stats:~statsMFCCbuf[voice], startChan: 1, numDerivs: 1, weights: ~weightMFCCbuf[voice], trig:Done.kr(mfccweights), blocking: 1);//remove mfcc0 and weigh by loudness instead
	mfccflat = FluidBufFlatten.kr(~statsMFCCbuf[voice],~flatMFCCbuf[voice],trig:Done.kr(mfccstats),blocking: 1);
	FluidDataSetWr.kr(~mfccDS,label, -1, ~flatMFCCbuf[voice], Done.kr(mfccflat),blocking: 1);
});

)
//////////////////////////////////////////////////////////////////////////
//loading process

//load and play to test if it is that quick - it is!
(
t = Main.elapsedTime;
~loader.play(s,action:{(Main.elapsedTime - t).postln;"Loaded".postln;{var start, stop; PlayBuf.ar(~loader.index[~loader.index.keys.asArray.last.asSymbol][\numchans],~loader.buffer,startPos: ~loader.index[~loader.index.keys.asArray.last.asSymbol][\bounds][0])}.play;});
)

//////////////////////////////////////////////////////////////////////////
// slicing process

// run the slicer
(
t = Main.elapsedTime;
~slicer.play(s,~loader.buffer,~loader.index,action:{(Main.elapsedTime - t).postln;"Slicing done".postln});
)
//slice count
~slicer.index.keys.size

//////////////////////////////////////////////////////////////////////////
// description process

// run the descriptor extractor (errors will be given, this is normal: the pitch conditions are quite exacting and therefore many slices are not valid)
(
t = Main.elapsedTime;
~extractor.play(s,~loader.buffer,~slicer.index,action:{(Main.elapsedTime - t).postln;"Features done".postln});
)

// make a dataset of durations for querying that too (it could have been made in the process loop, but hey, we have dictionaries we can manipulate too!)
(
~dict = Dictionary.new;
~temp = ~slicer.index.collect{ |k| [k[\bounds][1] - k[\bounds][0]]};
~dict.add(\data -> ~temp);
~dict.add(\cols -> 1);
~durDS.load(~dict)
)

//////////////////////////////////////////////////////////////////////////
// manipulating and querying the data

~pitchDS.print;
~loudDS.print;
~mfccDS.print;
~durDS.print;

///////////////////////////////////////////////////////
//reduce the MFCC timbral space stats (many potential ways to explore here... just 2 provided for fun)
~tempDS = FluidDataSet(s,\temp11);

~query = FluidDataSetQuery(s);
~query.addRange(0,24);//add only means and stddev of the 12 coeffs...
~query.addRange((7*12),24);// and the same stats of the first derivative (moving 7 stats x 12 mfccs to the right)
~query.transform(~mfccDS, ~tempDS);

//check
~tempDS.print;

//shrinking A: PCA then standardize
~pca = FluidPCA(s,4);//shrink to 4 dimensions

~timbreDSp = FluidDataSet(s,\timbreDSp11);
~pca.fitTransform(~tempDS,~timbreDSp,{|x|x.postln;})//accuracy

// shrinking B: standardize then PCA
// https://scikit-learn.org/stable/auto_examples/preprocessing/plot_scaling_importance.html
~pca2 = FluidPCA(s,4);//shrink to 4 dimensions
~stan = FluidStandardize(s);
~stanDS = FluidDataSet(s,\stan11);
~stan.fitTransform(~tempDS,~stanDS)
~timbreDSsp = FluidDataSet(s,\timbreDSsp11);
~pca2.fitTransform(~stanDS,~timbreDSsp,{|x|x.postln;})//accuracy

// comparing NN for fun
~targetDSp = Buffer(s)
~targetDSsp = Buffer(s)
~tree = FluidKDTree(s,5)

// you can run this a few times to have fun
(
~target = ~slicer.index.keys.asArray.scramble.[0].asSymbol;
~timbreDSp.getPoint(~target, ~targetDSp);
~timbreDSsp.getPoint(~target, ~targetDSsp);
)

~tree.fit(~timbreDSp,{~tree.kNearest(~targetDSp,{|x|~nearestDSp = x.postln;})})
~tree.fit(~timbreDSsp,{~tree.kNearest(~targetDSsp,{|x|~nearestDSsp = x.postln;})})

// play them in a row
(
Routine{
5.do{|i|
	var dur;
	v = ~slicer.index[~nearestDSp[i].asSymbol];
	dur = (v[\bounds][1] - v[\bounds][0]) / s.sampleRate;
	{BufRd.ar(v[\numchans],~loader.buffer,Line.ar(v[\bounds][0],v[\bounds][1],dur, doneAction: 2))}.play;
	~nearestDSp[i].postln;
	dur.wait;
	};
}.play;
)

(
Routine{
5.do{|i|
	var dur;
	v = ~slicer.index[~nearestDSsp[i].asSymbol];
	dur = (v[\bounds][1] - v[\bounds][0]) / s.sampleRate;
	{BufRd.ar(v[\numchans],~loader.buffer,Line.ar(v[\bounds][0],v[\bounds][1],dur, doneAction: 2))}.play;
	~nearestDSsp[i].postln;
	dur.wait;
	};
}.play;
)

///////////////////////////////////////////////////////
// compositing queries - defining a target and analysing it

~globalDS = FluidDataSet(s,\global11);

// define a source
~targetsound = Buffer.read(s,Platform.resourceDir +/+ "sounds/a11wlk01.wav",startFrame: 18000,numFrames: 24000);
~targetsound.play

// analyse it as above, using voice 0 in the arrays of buffer to store the info
(
{
	var label, voice, pitch, pitchweights, pitchstats, pitchflat, loud, statsLoud, flattenLoud, mfcc, mfccweights, mfccstats, mfccflat, writePitch, writeLoud;
	pitch = FluidBufPitch.kr(~targetsound, numChans:1, features:~pitchbuf[0], unit: 1, trig:1, blocking: 1);
	pitchweights = FluidBufThresh.kr(~pitchbuf[0], numChans: 1, startChan: 1, destination: ~weightPitchbuf[0], threshold: 0.1, trig:Done.kr(pitch), blocking: 1);
	pitchstats = FluidBufStats.kr(~pitchbuf[0], stats:~statsPitchbuf[0], numDerivs: 1, weights: ~weightPitchbuf[0], outliersCutoff: 1.5, trig:Done.kr(pitchweights), blocking: 1);
	pitchflat = FluidBufFlatten.kr(~statsPitchbuf[0],~flatPitchbuf[0],trig:Done.kr(pitchstats),blocking: 1);
	loud = FluidBufLoudness.kr(~targetsound, numChans:1, features:~loudbuf[0], trig:Done.kr(pitchflat), blocking: 1);
	statsLoud = FluidBufStats.kr(~loudbuf[0], stats:~statsLoudbuf[0], numDerivs: 1, trig:Done.kr(loud), blocking: 1);
	flattenLoud = FluidBufFlatten.kr(~statsLoudbuf[0],~flatLoudbuf[0],trig:Done.kr(statsLoud),blocking: 1);
	mfcc = FluidBufMFCC.kr(~targetsound,numChans:1,features:~mfccbuf[0],trig:Done.kr(flattenLoud),blocking: 1);
	mfccweights = FluidBufScale.kr(~loudbuf[0],numChans: 1,destination: ~weightMFCCbuf[0],inputLow: -70,inputHigh: 0, trig: Done.kr(mfcc), blocking: 1);
	mfccstats = FluidBufStats.kr(~mfccbuf[0], stats:~statsMFCCbuf[0], startChan: 1, numDerivs: 1, weights: ~weightMFCCbuf[0], trig:Done.kr(mfccweights), blocking: 1);
	mfccflat = FluidBufFlatten.kr(~statsMFCCbuf[0],~flatMFCCbuf[0],trig:Done.kr(mfccstats),blocking: 1);
	FreeSelf.kr(Done.kr(mfccflat));
}.play;
)

// a first query - length and pitch
~query.clear
~query.filter(0,"<",22050)//column0 smaller than half a second but
~query.and(0,">", 11025)//also larger than a quarter of second
~query.transformJoin(~durDS, ~pitchDS, ~tempDS); //this passes to ~tempDS only the points that have the same label than those in ~durDS that satisfy the condition. No column were added so nothing from ~durDS is copied

// print to see
~tempDS.print

// further conditions to assemble the query
~query.clear
~query.filter(11,">",0.7)//column11 (median of pitch confidence) larger than 0.7
~query.addRange(0,4) //copy only mean and stddev of pitch and confidence
~query.transform(~tempDS, ~globalDS); // pass it to the final search

// print to see
~globalDS.print

// compare knearest on both globalDS and tempDS
// assemble search buffer
~targetPitch = Buffer(s)
FluidBufCompose.process(s, ~flatPitchbuf[0],numFrames: 4,destination: ~targetPitch)

// feed the trees
~tree.fit(~pitchDS,{~tree.kNearest(~flatPitchbuf[0],{|x|~nearestA = x.postln;})}) //all the points with all the stats
~tree.fit(~globalDS,{~tree.kNearest(~targetPitch,{|x|~nearestB = x.postln;})}) //just the points with the right lenght conditions, with the curated stats

// play them in a row
(
Routine{
5.do{|i|
	var dur;
	v = ~slicer.index[~nearestA[i].asSymbol];
	dur = (v[\bounds][1] - v[\bounds][0]) / s.sampleRate;
	{BufRd.ar(v[\numchans],~loader.buffer,Line.ar(v[\bounds][0],v[\bounds][1],dur, doneAction: 2))}.play;
	~nearestA[i].postln;
	dur.wait;
	};
}.play;
)

(
Routine{
5.do{|i|
	var dur;
	v = ~slicer.index[~nearestB[i].asSymbol];
	dur = (v[\bounds][1] - v[\bounds][0]) / s.sampleRate;
	{BufRd.ar(v[\numchans],~loader.buffer,Line.ar(v[\bounds][0],v[\bounds][1],dur, doneAction: 2))}.play;
	~nearestB[i].postln;
	dur.wait;
	};
}.play;
)

///////////////////////////////////////////////////////
// compositing queries to weigh - defining a target and analysing it

// make sure to define and describe the source above (lines 178 to 201)

// let's make normalised versions of the 3 datasets, keeping the normalisers separate to query later
~loudDSn = FluidDataSet(s,\loud11n);
~pitchDSn = FluidDataSet(s,\pitch11n);
~timbreDSn = FluidDataSet(s,\timbre11n);

~normL = FluidNormalize(s)
~normP = FluidNormalize(s)
~normT = FluidNormalize(s)

~normL.fitTransform(~loudDS, ~loudDSn);
~normP.fitTransform(~pitchDS, ~pitchDSn);
~normT.fitTransform(~timbreDSp, ~timbreDSn);

// let's assemble these datasets
~query.clear
~query.addRange(0,4)
~query.transformJoin(~pitchDSn,~timbreDSn, ~tempDS) //appends 4 dims of pitch to 4 dims of timbre
~query.transformJoin(~loudDSn, ~tempDS, ~globalDS) // appends 4 dims of loud to the 8 dims above

~globalDS.print//12 dim: 4 timbre, 4 pitch, 4 loud, all normalised between 0 and 1

// let's assemble the query
// first let's normalise our target descriptors
~targetPitch = Buffer(s)
~targetLoud = Buffer(s)
~targetMFCC = Buffer(s)
~targetMFCCsub = Buffer(s)
~targetTimbre = Buffer(s)
~targetAll= Buffer(s)

~normL.transformPoint(~flatLoudbuf[0], ~targetLoud) //normalise the loudness (all dims)
~normP.transformPoint(~flatPitchbuf[0], ~targetPitch) //normalise the pitch (all dims)
FluidBufCompose.process(s,~flatMFCCbuf[0],numFrames: 24,destination: ~targetMFCCsub) // copy the process of dimension reduction above
FluidBufCompose.process(s,~flatMFCCbuf[0],startFrame: (7*12), numFrames: 24, destination: ~targetMFCCsub,destStartFrame: 24) //keeping 48 dims
~pca.transformPoint(~targetMFCCsub, ~targetMFCC) //then down to 4
~normT.transformPoint(~targetMFCC, ~targetTimbre) //then normalised
FluidBufCompose.process(s, ~targetTimbre,destination: ~targetAll) // assembling the single query
FluidBufCompose.process(s, ~targetPitch, numFrames: 4, destination: ~targetAll, destStartFrame: 4) // copying the 4 stats of pitch we care about
FluidBufCompose.process(s, ~targetLoud, numFrames: 4, destination: ~targetAll, destStartFrame: 8) // same for loudness
//check the sanity
~targetAll.query

// now let's see which is nearest that point
~tree.fit(~globalDS,{~tree.kNearest(~targetAll,{|x|~nearest = x.postln;})}) //just the points with the right lenght conditions, with the curated stats

// play them in a row
(
Routine{
5.do{|i|
	var dur;
	v = ~slicer.index[~nearest[i].asSymbol];
	dur = (v[\bounds][1] - v[\bounds][0]) / s.sampleRate;
	{BufRd.ar(v[\numchans],~loader.buffer,Line.ar(v[\bounds][0],v[\bounds][1],dur, doneAction: 2))}.play;
	~nearest[i].postln;
	dur.wait;
	};
}.play;
)

// to change the relative weight of each dataset, let's change the normalisation range. Larger ranges will mean larger distance, and therefore less importance for that parameter.
// for instance to downplay pitch, let's make it larger by a factor of 2
~normP.max = 2
~normP.fitTransform(~pitchDS, ~pitchDSn);
// here we can re-run just the part that composites the pitch
~normP.transformPoint(~flatPitchbuf[0], ~targetPitch) //normalise the pitch (all dims)
FluidBufCompose.process(s, ~targetPitch, numFrames: 4, destination: ~targetAll, destStartFrame: 4) // copying the 4 stats of pitch we care about

// now let's see which is nearest that point
~tree.fit(~globalDS,{~tree.kNearest(~targetAll,{|x|~nearest = x.postln;})}) //just the points with the right lenght conditions, with the curated stats

// todo: segment then query musaik