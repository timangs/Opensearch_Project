import Header from './header/header';
import * as S from './styles';

export default function Layout({ children }: { children: any }) {
  return (
    <S.Wrapper id='layout-wrapper'>
      <Header />
      <S.Child_Wrapper>{children}</S.Child_Wrapper>
    </S.Wrapper>
  );
}
