import 'package:azkar/main.dart';
import 'package:azkar/models/friend.dart';
import 'package:azkar/net/payload/users/responses/resolve_friend_request_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:flutter/material.dart';

class FriendRequestWidget extends StatefulWidget {
  final Friend friend;
  final State parentState;

  FriendRequestWidget({@required this.friend, @required this.parentState});

  @override
  _FriendRequestWidgetState createState() => _FriendRequestWidgetState();
}

class _FriendRequestWidgetState extends State<FriendRequestWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: IntrinsicHeight(
        child: Row(
          children: [
            Flexible(
              flex: 7,
              fit: FlexFit.tight,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.friend.firstName} ${widget.friend.lastName}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.friend.username}',
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: VerticalDivider(
                width: 3,
                color: Colors.black,
              ),
            ),
            Flexible(
              flex: 6,
              fit: FlexFit.tight,
              child: Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      child: Text(AppLocalizations.of(context).accept),
                      color: Colors.green.shade400,
                      onPressed: () => onAcceptedPressed(),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    // ignore: deprecated_member_use
                    child: OutlineButton(
                      child: (Text(AppLocalizations.of(context).ignore)),
                      onPressed: () => onRejectedPressed(),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onAcceptedPressed() async {
    ResolveFriendRequestResponse response =
        await ServiceProvider.usersService.acceptFriend(widget.friend.userId);
    if (response.hasError()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error.errorMessage),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green.shade400,
        content: Text(
            '${widget.friend.firstName} ${widget.friend.lastName} ${AppLocalizations.of(context).isNowYourFriend}'),
      ));
      widget.parentState.setState(() {});
    }
  }

  void onRejectedPressed() async {
    ResolveFriendRequestResponse response =
        await ServiceProvider.usersService.rejectFriend(widget.friend.userId);
    if (response.hasError()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error.errorMessage),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "${AppLocalizations.of(context).friendRequest} ${widget.friend.firstName} ${widget.friend.lastName} ${AppLocalizations.of(context).isIgnored}"),
      ));
      widget.parentState.setState(() {});
    }
  }
}