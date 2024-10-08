import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zeko_hotel_crm/core/date_parser.dart';
import 'package:zeko_hotel_crm/features/order_management/data/entities/pending_orders_dto.dart';
import 'package:zeko_hotel_crm/main.dart';
import 'package:zeko_hotel_crm/shared/widgets/widgets.dart';
import 'package:zeko_hotel_crm/utils/extensions/extensions.dart';
import 'package:zeko_hotel_crm/utils/utils.dart';

class OrderItemCard extends StatelessWidget {
  final OrderCategory order;

  const OrderItemCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          basicDetail(order.id, order.timeStamp, order.isEscalated),
          const Divider(),
          itemListing(order.items),
          const Divider(),
          guestDetail(order.category, order.roomNumber),
          const Divider(),
          orderConfirmation(order.items),
        ],
      ).padding(Paddings.contentPadding),
    );
  }

  Row orderActions() {
    return Row(
      children: [
        FilledButton(
          onPressed: () {},
          style: const ButtonStyle(
              elevation: WidgetStatePropertyAll(0),
              backgroundColor: WidgetStatePropertyAll(Colors.green)),
          child: Text(
            'Accept',
            style: textStyles.bodySmall?.copyWith(color: Colors.white),
          ),
        ).expanded(),
        Spacing.wlg,
        FilledButton(
          onPressed: () {},
          style: const ButtonStyle(
              elevation: WidgetStatePropertyAll(0),
              backgroundColor: WidgetStatePropertyAll(Colors.red)),
          child: Text(
            'Reject',
            style: textStyles.bodySmall?.copyWith(color: Colors.white),
          ),
        ).expanded(),
      ],
    );
  }

  Widget basicDetail(int id, String timeStamp, bool isEscalated) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order #$id',
              style:
                  textStyles.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Spacing.hxs,
            Text(
              timeStamp.toCustom('EEE, MMM dd, yyyy hh:mm a'),
              style: textStyles.bodySmall,
            ),
          ],
        ).expanded(),
        if (isEscalated == true) ...[
          Center(
              child: const Icon(
            Icons.notification_important_outlined,
            color: Colors.red,
          )
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                  )
                  .fade(duration: 1.5.seconds))
        ],
      ],
    );
  }

  Widget itemListing(List<OrderItem> items) {
    return Column(
      children: items.map((item) {
        return CheckboxListTile.adaptive(
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: Colors.purple,
          checkboxShape:
              const RoundedRectangleBorder(borderRadius: Corners.medBorder),
          value: true,
          onChanged: (v) {},
          contentPadding: EdgeInsets.zero,
          title: Text(
            '${item.item.name}',
            style: textStyles.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          dense: true,
          subtitle: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (item.item.description != null) ...[
                    Text(
                      '${item.item.description}',
                      style: textStyles.bodySmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                  Spacing.hsm,
                  Row(
                    children: [
                      // If discount price is available, then strike the original price.
                      if (item.item.discPrice != null) ...[
                        RichText(
                          text: TextSpan(
                              text:
                                  '$hotelCurrency${item.item.discPrice.toString().removeZero()} ',
                              style: textStyles.bodyMedium,
                              children: [
                                TextSpan(
                                    text:
                                        '$hotelCurrency${item.item.price.toString().removeZero()}',
                                    style: textStyles.bodySmall?.copyWith(
                                        decoration: TextDecoration.lineThrough))
                              ]),
                        ).expanded(),
                      ],
                      // If discount price is not available, then show the original price.
                      if (item.item.discPrice == null) ...[
                        Text(
                          '$hotelCurrency${item.item.price.toString().removeZero()}',
                          style: textStyles.bodyMedium,
                        ).expanded(),
                      ],

                      Text(
                        'Qty: ${item.quantity}',
                        style: textStyles.labelMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ).expanded(),
              Spacing.wmed,
              ClipRRect(
                  borderRadius: Corners.lgBorder,
                  child: AppImage(height: 40, width: 40, src: item.item.image)),
            ],
          ),
        ).horizontalGapZero();
      }).toList(),
    );
  }

  Widget guestDetail(String category, String roomNumber) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RichText(
            text: TextSpan(
                style: textStyles.labelLarge,
                text: 'Menu ',
                children: [
              TextSpan(
                text: category,
                style: textStyles.labelMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              )
            ])),
        RichText(
            text: TextSpan(
                style: textStyles.labelLarge,
                text: 'Room ',
                children: [
              TextSpan(
                text: roomNumber,
                style: textStyles.labelMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              )
            ])),
      ],
    );
  }

  Widget orderConfirmation(List<OrderItem> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FilledButton.icon(
            style: ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: Corners.lgBorder,
                    side: BorderSide(color: Colors.green.shade400))),
                backgroundColor: WidgetStatePropertyAll(
                    Colors.green.shade100.withOpacity(0.3))),
            onPressed: () {},
            label: Text(
              'Accept',
              style: textStyles.bodyMedium,
            ),
            icon: const Icon(
              CupertinoIcons.checkmark_alt,
              color: Colors.green,
            )).expanded(),
        Spacing.wmed,
        FilledButton.icon(
            style: ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: Corners.lgBorder,
                    side: BorderSide(color: Colors.red.shade400))),
                backgroundColor: WidgetStatePropertyAll(
                    Colors.red.shade100.withOpacity(0.3))),
            onPressed: () {},
            label: Text(
              'Reject',
              style: textStyles.bodyMedium,
            ),
            icon: Icon(
              CupertinoIcons.xmark,
              color: Colors.red.shade400,
            )).expanded(),
      ],
    );
  }
}
