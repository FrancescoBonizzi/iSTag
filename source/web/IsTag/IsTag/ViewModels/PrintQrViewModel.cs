namespace IsTag.ViewModels
{
    public class PrintQrViewModel
    {
        public string QrCode { get; }
        public string Name { get; }
        public string QrCodeSizeClass { get; }
        public string QrTitleSizeClass { get; }

        public PrintQrViewModel(
            string qrCode,
            string name,
            int size)
        {
            QrCode = qrCode;
            Name = name;

            if (size == 1)
            {
                QrCodeSizeClass = "qrImage1x";
                QrTitleSizeClass = "qrTitle1x";
            }
            else if (size == 2)
            {
                QrCodeSizeClass = "qrImage2x";
                QrTitleSizeClass = "qrTitle2x";
            }
            else if (size == 3)
            {
                QrCodeSizeClass = "qrImage3x";
                QrTitleSizeClass = "qrTitle3x";
            }
            else
            {
                QrCodeSizeClass = "qrImage1x";
                QrTitleSizeClass = "qrTitle1x";
            }
        }
    }
}
