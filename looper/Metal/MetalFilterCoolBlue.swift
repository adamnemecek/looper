import MetalPerformanceShaders

class MetalFilterCoolBlue:MetalFilter
{
    private let kHistogramEntries:Int = 256
    private let kAlphaChannel:ObjCBool = false
    private let kMinPixelValue:Float = 0
    private let kMaxCyanPixelValue:Float = 0.5
    private let kMaxMagentaPixelValue:Float = 0.32
    private let kMaxYellowPixelValue:Float = 0.2
    private let kMaxKeyPixelValue:Float = 1
    private let kHistogramOffset:Int = 0
    
    //MARK: public
    
    func render(
        sourceTexture:MTLTexture,
        destinationTexture:MTLTexture)
    {
        guard
            
            let commandBuffer:MTLCommandBuffer = self.commandBuffer
        
        else
        {
            return
        }
        
        let minPixel:vector_float4 = vector_float4(kMinPixelValue)
        
        let maxPixel:vector_float4 = vector_float4(
            kMaxCyanPixelValue,
            kMaxMagentaPixelValue,
            kMaxYellowPixelValue,
            kMaxKeyPixelValue)
        
        var histogramInfo:MPSImageHistogramInfo = MPSImageHistogramInfo(
            numberOfHistogramEntries:kHistogramEntries,
            histogramForAlpha:kAlphaChannel,
            minPixelValue:minPixel,
            maxPixelValue:maxPixel)
        
        let histogramOptions:MTLResourceOptions = MTLResourceOptions([
            MTLResourceOptions.storageModePrivate])
        
        let calculation:MPSImageHistogram = MPSImageHistogram(
            device:device,
            histogramInfo:&histogramInfo)
        
        let equalization:MPSImageHistogramEqualization = MPSImageHistogramEqualization(
            device:device,
            histogramInfo:&histogramInfo)
        
        let pixelFormat:MTLPixelFormat = sourceTexture.pixelFormat
        let histogramSize:Int = calculation.histogramSize(
            forSourceFormat:pixelFormat)
        let histogramBuffer:MTLBuffer = device.makeBuffer(
            length:histogramSize,
            options:histogramOptions)
        
        calculation.encode(
            to:commandBuffer,
            sourceTexture:sourceTexture,
            histogram:histogramBuffer,
            histogramOffset:kHistogramOffset)
        
        equalization.encodeTransform(
            to:commandBuffer,
            sourceTexture:sourceTexture,
            histogram:histogramBuffer,
            histogramOffset:kHistogramOffset)
        
        equalization.encode(
            commandBuffer:commandBuffer,
            sourceTexture:sourceTexture,
            destinationTexture:destinationTexture)
    }
}
