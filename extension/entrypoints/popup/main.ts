import './style.css';

// index.html の <div id="app"> の中身を書き換える
// ! は「この要素は必ずある」と TypeScript に伝える記号
document.querySelector<HTMLDivElement>('#app')!.innerHTML = `
  <h1>Mock Gallery Saver</h1>
  <p>ギャラリーを開くと、ここに画像の枚数が表示されます。</p>
`;
