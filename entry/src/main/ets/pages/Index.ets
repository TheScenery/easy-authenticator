import { Header } from '../components/Header';
import { PasswordItem } from '../components/PasswordItem';

@Entry
@Component
struct Index {
  build() {
    Column() {
      Header()
      List() {
        ListItem() {
          PasswordItem()
        }

        ListItem() {
          PasswordItem()
        }
      }.divider({
        strokeWidth: 2
      })
    }
    .height('100%')
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}