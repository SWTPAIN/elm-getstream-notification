module Update exposing (init, update, subscriptions)

import Model exposing (..)
import Ports
import Components.NotificationItem.Model as NotificationItemModel
import GetStream

init : (Model, Cmd Msg)
init =
  (
    {
      notifications = []
    , userId = Nothing
    },
    Cmd.none
  )

update : Msg -> Model -> (Model, Cmd msg)
update msg model =
  case msg of
    NoOp -> (model, Cmd.none)
    LoadMoreNotifications -> (model, Ports.loadMoreNotifications())
    NewNotifications notifications -> ({model | notifications = notifications}, Cmd.none)
    NotificationItemMsg notificationItemMsg ->
      case notificationItemMsg of
        NotificationItemModel.MarkAsSeen notificationItemId ->
          ({model | notifications = (model.notifications |> markNotificationAsSeen(notificationItemId))}, GetStream.markOneNotificationAsSeen(notificationItemId))

markNotificationAsSeen : NotificationItemModel.NotificationId -> List NotificationItemModel.Notification ->  List NotificationItemModel.Notification
markNotificationAsSeen id notifications =
  let
    updateNotificartion noti =
      if noti.id == id then
        {noti | isSeen = True}
      else
        noti
  in    
    List.map updateNotificartion notifications
-- Subscription
subscriptions : Model -> Sub Msg
subscriptions model =
  Ports.notifications (\notifications -> NewNotifications notifications)

