// ギャラリー上の画像1枚分の情報
export interface GalleryImage {
  id: string;          // 画像の ID
  originalUrl: string; // 元画像の URL
}

// サイトごとのアダプターが必ず持っているべきもの
export interface SiteAdapter {
  name: string;                                // アダプターの名前（例: "mock-gallery"）
  findImages(doc: Document): GalleryImage[];   // ページから画像を探して返す
}