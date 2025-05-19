import { css } from '@emotion/react';

const globalStyle = css`
  * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
  }

  body {
    /* background-color: red; */
    background-image: url('/sportsbg.png');
    background-size: cover;
    background-attachment: fixed;
  }

  html,
  body,
  #__next {
    margin: 0;
    padding: 0;
    width: 100%;
    height: 100%;
    position: relative;
    overflow: visible;
  }

  // 폰트
  /* @font-face {
    font-family: 'NanumSquareNeo';
    font-style: normal;
    font-weight: 200;
    src: url('/public/fonts/NanumSquareNeo-aLt.ttf') format('ttf');
  }
  @font-face {
    font-family: 'NanumSquareNeo';
    font-style: normal;
    font-weight: 300;
    src: url('/public/fonts/NanumSquareNeo-bRg.ttf') format('ttf');
  }
  @font-face {
    font-family: 'NanumSquareNeo';
    font-style: normal;
    font-weight: 400;
    src: url('/public/fonts/NanumSquareNeo-cBd.ttf') format('ttf');
  }
  @font-face {
    font-family: 'NanumSquareNeo';
    font-style: normal;
    font-weight: 500;
    src: url('/public/fonts/NanumSquareNeo-dEb.ttf') format('ttf');
  }
  @font-face {
    font-family: 'NanumSquareNeo';
    font-style: normal;
    font-weight: 700;
    src: url('/public/fonts/NanumSquareNeo-eHv.ttf') format('ttf');
  } */
`;

export default globalStyle;
