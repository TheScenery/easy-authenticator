import { PasswordItem } from '../components/PasswordItem';

@Entry
@Component
struct Index {

  build() {
    RelativeContainer() {
      List(){
        ListItem(){
          PasswordItem()
        }
        ListItem(){
          PasswordItem()
        }
      }.divider({
        strokeWidth: 2
      })
    }
    .height('100%')
    .width('100%')
  }
}