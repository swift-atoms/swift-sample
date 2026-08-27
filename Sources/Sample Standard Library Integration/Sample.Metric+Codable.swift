public import Sample

#if !hasFeature(Embedded)
    extension Sample.Metric: Codable {}
#endif
