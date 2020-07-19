s.reboot;
//Preliminaries: we want some audio, a couple of FluidDataSets, some Buffers
(
~raw = FluidDataSet(s,\MLP40);
~retrieved = FluidDataSet(s,\ae2);
~audio = Buffer.read(s,File.realpath(FluidBufMelBands.class.filenameSymbol).dirname +/+ "../AudioFiles/Tremblay-ASWINE-ScratchySynth-M.wav");
~melfeatures = Buffer.new(s);
~stats = Buffer.alloc(s, 7, 40);
~datapoint = Buffer.alloc(s, 40);
~mlp = FluidMLPRegressor(s,[10,2,10],1,1,2,10000,0.01,0.1,10,0);
)

// process the melbands
FluidBufMelBands.process(s,~audio, features: ~melfeatures,action: {\done.postln;});

~raw.free
// Divide the time series in 100, and take the mean of each segment and add this as a point to
// the 'raw' FluidDataSet
(
{
    var trig = LocalIn.kr(1, 1);
    var buf =  LocalBuf(40, 1);
    var count = PulseCount.kr(trig) - 1;
    var chunkLen = (~melfeatures.numFrames / 100).asInteger;
    var stats = FluidBufStats.kr(source: ~melfeatures, startFrame: count * chunkLen, numFrames: chunkLen, stats: ~stats, trig: trig);
    var rd = BufRd.kr(40, ~stats, DC.kr(0), 0, 1);
    var bufWr, dsWr;
    40.do{|i|
        bufWr = BufWr.kr(rd[i], buf, DC.kr(i));
    };
    dsWr = FluidDataSetWr.kr(\MLP40, buf: buf, trig: Done.kr(stats));
    LocalOut.kr( Done.kr(dsWr));
    FreeSelf.kr(count - 99);
}.play;
)
// wait for the post window to acknoledge the job is done.

//we can then run the AE - the server might become yellow :)
~mlp.fit(~raw,~raw,{|x|x.postln;});

//we can then retrieve the hidden layer #2
~mlp.predict(~raw,~retrieved)

//check the structure of retrieved
~retrieved.print

//let's normalise it for display
~normData = FluidDataSet(s,\ae2N);
~reducedarray = Array.new(100);
~normalizer = FluidNormalize(s);
~normalizer.fitTransform(~retrieved,~normData, action:{
    ~normData.dump{|x| 100.do{|i|
        ~reducedarray.add(x["data"][i.asString])
    }};
});

~normData.print
~reducedarray.postln;


//Visualise the 2D projection of our original 12D data
(
d = ~reducedarray.flatten(1).unlace.deepCollect(1, { |x| x.normalize});
w = Window("scatter", Rect(128, 64, 200, 200));
w.drawFunc = {
    Pen.use {
        d[0].size.do{|i|
            var x = (d[0][i]*200);
            var y = (d[1][i]*200);
            var r = Rect(x,y,5,5);
            Pen.fillColor = Color.blue;
            Pen.fillOval(r);
        }
    }
};
w.refresh;
w.front;
)