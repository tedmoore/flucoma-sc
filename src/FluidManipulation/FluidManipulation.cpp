
// A tool from the FluCoMa project, funded by the European Research Council (ERC) under the European Union’s Horizon 2020 research and innovation programme (grant agreement No 725899)

#include <clients/nrt/DataSetClient.hpp>
#include <clients/nrt/LabelSetClient.hpp>
#include <clients/nrt/KDTreeClient.hpp>
#include <clients/nrt/KMeansClient.hpp>
#include <clients/nrt/KNNClient.hpp>
#include <clients/nrt/NormalizeClient.hpp>
#include <clients/nrt/StandardizeClient.hpp>
#include <clients/rt/AudioTransportClient.hpp>
#include <FluidSCWrapper.hpp>

static InterfaceTable *ft;

PluginLoad(FluidSTFTUGen)
{
  ft = inTable;
  using namespace fluid::client;
  makeSCWrapper<NRTThreadedDataSetClient>("FluidDataSet",ft);
  makeSCWrapper<NRTThreadedLabelSetClient>("FluidLabelSet",ft);
  makeSCWrapper<NRTThreadedKDTreeClient>("FluidKDTree",ft);
  makeSCWrapper<NRTThreadedKMeansClient>("FluidKMeans",ft);
  makeSCWrapper<NRTThreadedKNNClient>("FluidKNN",ft);
  makeSCWrapper<NRTThreadedNormalizeClient>("FluidNormalize",ft);
  makeSCWrapper<NRTThreadedStandardizeClient>("FluidStandardize",ft);
  makeSCWrapper<RTAudioTransportClient>("FluidAudioTransport",ft);
  makeSCWrapper<NRTThreadedAudioTransportClient>("FluidBufAudioTransport",ft);
}
