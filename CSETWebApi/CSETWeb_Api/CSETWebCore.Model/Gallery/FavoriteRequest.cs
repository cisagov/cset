////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//
////////////////////////////////
using System;

namespace CSETWebCore.Model.Gallery;

public class FavoriteRequest
{
    public Guid GalleryItemGuid { get; set; }
    public bool IsFavorite { get; set; }
}